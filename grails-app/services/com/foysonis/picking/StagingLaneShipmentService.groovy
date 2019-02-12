package com.foysonis.picking

import com.foysonis.orders.ShipmentStatus
import grails.transaction.Transactional
import com.foysonis.area.Area
import groovy.sql.Sql

@Transactional
class StagingLaneShipmentService {
    def sessionFactory

    def getLocations(companyId, isStaging, keyword) {
        def keyLocationId = '%'+keyword+'%'
        def sqlQuery = "SELECT l.location_id as contactName FROM area as a INNER JOIN location as l ON a.area_id = l.area_id WHERE l.company_id = '${companyId}' AND a.is_staging ='1' AND l.location_id LIKE '${keyLocationId}' AND l.is_blocked ='0';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getLocationsByArea(companyId, isStaging, keyword) {
        def stagingArea = Area.findAllByCompanyIdAndIsStaging(companyId, true)
        def keyLocationId = '%'+keyword+'%'
        def sqlQuery = null

        if(stagingArea.size()>1){
            sqlQuery = "SELECT l.location_id, CONCAT(l.location_id,' - ', a.area_id) as contactName FROM area as a INNER JOIN location as l ON a.area_id = l.area_id AND a.company_id = '${companyId}' WHERE l.company_id = '${companyId}' AND a.is_staging ='1' AND l.location_id LIKE '${keyLocationId}' AND l.is_blocked ='0';"
        }

        else{
            sqlQuery = "SELECT l.location_id, l.location_id as contactName FROM area as a INNER JOIN location as l ON a.area_id = l.area_id AND a.company_id = '${companyId}' WHERE l.company_id = '${companyId}' AND a.is_staging ='1' AND l.location_id LIKE '${keyLocationId}' AND l.is_blocked ='0';"
        }

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }






    def getShipment(companyId, locationId) {
        String sqlQuery = "SELECT * FROM shipment as sh " +
                "INNER JOIN shipment_line as sl ON sl.shipment_id = sh.shipment_id AND sl.company_id = '${companyId}' " +
                "INNER JOIN orders as o ON sl.order_number = o.order_number AND o.company_id = '${companyId}' " +
                "INNER JOIN customer as c ON o.customer_id = c.customer_id AND c.company_id = '${companyId}' " +
                "WHERE sh.company_id = '${companyId}' AND sh.staging_location_id = '${locationId}' AND sh.shipment_status != '${ShipmentStatus.COMPLETED}'"

        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

    def getShipmentCancelAllocation(companyId, shipmentId){
        return StagingLaneShipment.findAllByCompanyIdAndShipmentId(companyId, shipmentId)
    }

    def getInventory(companyId, locationId) {
        def sqlQuery = "SELECT * FROM inventory_entity_attribute as iea WHERE iea.company_id = '${companyId}'AND iea.location_id = '${locationId}';"
        def sql = new Sql(sessionFactory.currentSession.connection())
        return sql.rows(sqlQuery)
    }

}
