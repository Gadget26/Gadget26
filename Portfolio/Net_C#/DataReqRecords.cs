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
        [ActionName("DataReqRecords")]
        public ClientResult DataReqRecords([FromBody] Filter request) //gets grid parameters back to the database
        {
            return LoadPagedClientResult("dbo.usp_DataRequest_Log_Master", //loads the results from db to actual page
                request.ToDBParameter());
        }
    }
}
