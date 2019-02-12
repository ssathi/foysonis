package com.foysonis.item

import grails.transaction.Transactional

import groovy.sql.Sql

@Transactional
class EntityLastRecordService {

	def sessionFactory

    def getLastRecordId(String companyId, String entityId){
    	def sqlQuery = "SELECT getLastRecordId('${companyId}', '${entityId}') as lastRecordId"
		def sql = new Sql(sessionFactory.currentSession.connection())
        def rows = sql.rows(sqlQuery)
        return rows[0]
    }

}
