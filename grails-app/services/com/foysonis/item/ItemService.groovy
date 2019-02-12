package com.foysonis.item

import com.foysonis.inventory.Inventory
import groovy.sql.Sql

import grails.transaction.Transactional

import javax.imageio.ImageIO
import java.awt.image.BufferedImage
import java.io.ByteArrayInputStream
import sun.misc.BASE64Decoder
import java.io.File
import java.io.InputStream

@Transactional
class ItemService {

    def sessionFactory

    def checkItemIdExist(companyId, itemId){
        return Item.findAll("from Item as i where i.companyId = '${companyId}' AND i.itemId = '${itemId}' ")
    }

    def checkStorageAttributesOfAreas(companyId, storageAttr){

        def findStrgAttr = null
        def strgAttrSize = null

        if (storageAttr instanceof String) {
            findStrgAttr = "'"+storageAttr+"'"
            strgAttrSize = 1
        }
        else{
            strgAttrSize = storageAttr.size()
            for (value in storageAttr ){
                if (findStrgAttr) {
                    findStrgAttr += ",'"+value+"'"
                }
                else{
                    findStrgAttr = "'"+value+"'"
                }

            }
        }


        def sqlQuery = "SELECT * FROM entity_attribute WHERE company_id = '${companyId}' AND entity_id = 'AREAS' AND config_group = 'STRG' AND config_value IN (${findStrgAttr}) GROUP BY config_key HAVING COUNT(config_key) = ${strgAttrSize}"
        def sqlQuery2 = sqlQuery.toString()
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery2)

    }

    def getAllStorageAttributeOfItem(companyId,itemId){

        return EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigKeyAndConfigGroup(companyId, 'ITEM' ,itemId,'STRG',[sort:'sortSequence'] )
        //return EntityAttribute.executeQuery("select configValue from EntityAttribute as ea where companyId = '${companyId}' AND entityId = 'ITEM' AND configKey = '${itemId}' AND configGroup = 'STRG' ")

    }

    def removeEntityAttributesByConfigKey(companyId, configKey){
        def entityAttributes = EntityAttribute.findAllByCompanyIdAndEntityIdAndConfigKey(companyId, "ITEM", configKey)

        if (entityAttributes) {

            for (entity in entityAttributes){
                entity.delete(flush: true, failOnError: true)
            }

        }

    }


    def findInventoryOfItemId(companyId,itemId){
        return Inventory.findAllByCompanyIdAndItemId(companyId,itemId)

    }


    def getItemEntityAttributeForSearchRow (companyId,selectedRowItem) {
        def sqlQuery = "SELECT group_concat(e.config_value separator ', ') as strg, i.* from item as i INNER JOIN entity_attribute as e ON i.item_id = e.config_key AND e.company_id = '${companyId}' WHERE i.company_id = '${companyId}' AND i.item_id = '${selectedRowItem}' AND entity_id = 'ITEM' AND config_group = 'STRG' ORDER BY sort_sequence ASC"
        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows
    }


    def searchResults(companyId,itemId,itemDescription,itemCategory,isLotTracked,isExpired,isCaseTracked,configValue) {

        def sqlQuery = "SELECT distinct i.*,l.* from item as i LEFT JOIN entity_attribute as e ON i.item_id = e.config_key LEFT JOIN list_value as l ON (i.item_category = l.option_value and l.option_group = 'ITEMCAT' and l.company_id = i.company_id )  " +
                "WHERE  i.company_id = '${companyId}' "

        if(itemId){
            def findItemId = '%'+itemId+'%'
            sqlQuery = sqlQuery + " AND (i.item_id LIKE '${findItemId}' OR i.upc_code LIKE '${findItemId}') "
        }

        if(itemDescription){
            def findItemDescription = '%'+itemDescription+'%'
            sqlQuery = sqlQuery + " AND (i.item_description LIKE '${findItemDescription}' )"
        }

        if(itemCategory){
            sqlQuery = sqlQuery + " AND i.item_category = '${itemCategory}'"
        }

        if(isLotTracked){
            sqlQuery = sqlQuery + " AND i.is_lot_tracked = ${isLotTracked}"
        }

        if(isExpired){
            sqlQuery = sqlQuery + " AND i.is_expired = ${isExpired}"
        }

        if(isCaseTracked){
            sqlQuery = sqlQuery + " AND i.is_case_tracked = ${isCaseTracked}"
        }

        if(configValue){
            sqlQuery = sqlQuery + " AND e.company_id = '${companyId}' AND e.entity_id = 'ITEM' AND e.config_value IN (${configValue}) "
        }


        sqlQuery = sqlQuery + " ORDER BY i.item_id ASC;"

        def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows

    }

    def getLowestUom(companyId, itemId) {
        return Item.findAllByCompanyIdAndItemId(companyId, itemId).lowestUom
    }

    def uploadImageFile(companyId, imageFile, ext, itemId, imagePath) {
        def uploadFile = imageFile
        def reportPath = imagePath
        File companyFilePath = new File("${reportPath}/${companyId}/items")
        println "------------------Directory? ${companyFilePath.isDirectory()}"
        if (!companyFilePath.isDirectory()) {
            println "creating Directory.............."
            File companyFilePathCreation = new File("${reportPath}/${companyId}")
            if (companyFilePathCreation.isDirectory()) {
                File itemFilePathCreation = new File("${reportPath}/${companyId}/items")
                itemFilePathCreation.mkdir()
            }else{
                companyFilePathCreation.mkdir()
                companyFilePath.mkdir()
            }
            
        }

        File newFile = new File("${companyFilePath}/${itemId}."+ext); //You create the destination file
        Random random = new Random()
        String imageFilePath = "images/${companyId}/items/${itemId}."+ext+"?ver="+random.nextInt(10 ** 6)
        def parts = uploadFile.tokenize(",");
        def imageString = parts[1];
        BufferedImage image = null;
        byte[] imageByte;

        BASE64Decoder decoder = new BASE64Decoder();
        imageByte = decoder.decodeBuffer(imageString);
        ByteArrayInputStream bArrayInputStream = new ByteArrayInputStream(imageByte);

        try {
            image = ImageIO.read(bArrayInputStream);
            bArrayInputStream.close();
            ImageIO.write(image, ext, newFile);
            return imageFilePath
        } catch (IOException e) {
            throw new RuntimeException(e);
        }


    }    

    def deleteImageFile(companyId, ext, itemId, imagePath) {
        def reportPath = imagePath
        File companyFilePath = new File("${reportPath}/${companyId}/items")
        File newFile = new File("${companyFilePath}/${itemId}."+ext); //You create the destination file
        if (newFile.isFile()) {
            newFile.delete()
            def itemRow = Item.findByCompanyIdAndItemId(companyId, itemId)
            if (itemRow) {
                itemRow.imagePath = null;
                itemRow.save(flush: true, failOnError: true)                
            }
            return [status:"success"]
        }
        else{
            return [status:"error"]
        }
    }    

}

