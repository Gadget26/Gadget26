﻿using BIACore.Model;
using BIACore.Web.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;

namespace DataRequest.WebAPI.Controller
{
    public partial class DataRequestFilterController
    {

        [HttpPost]
        [ActionName("BIAManager")]
        public ClientResult BIAManager([FromBody] dynamic request)
        {
            return LoadClientResult("dbo.usp_GetManager",
                null);
        }
    }
}
