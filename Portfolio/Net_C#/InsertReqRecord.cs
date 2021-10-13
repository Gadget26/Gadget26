using BIACore.Model;
using BIACore.Web.Model;
using DataRequest.WebAPI.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace DataRequest.WebAPI.Controller
{
    public partial class DataRequestReportController
    {
        [HttpPost]
        [ActionName("InsertReqRecords")]

       //public is wahats being accessed, void is the return type, and InsertReqRecords is the method name
        public void InsertReqRecords([FromBody] DataRequest.WebAPI.Model.DataRequest request) //gets grid parameters back to the database
        {
            //DBParameter[] dbParams = {
            //                             new DBParameter("Manager", DbType.String, request.ReqManager),
            //                             new DBParameter("Name", DbType.String, request.Name),
            //                             new DBParameter("ReqReceived", DbType.DateTime, request.ReqReceived),
            //                         };

            LoadResult("dbo.usp_Insert_DataRequest", request.DBParams()); //loads/calls the results from db to actual page

            
        }
    }
}
