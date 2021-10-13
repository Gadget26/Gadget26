using BIACore.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataRequest.WebAPI.Model
{
    public class DataRequest
    {
        public string ReqManager;
        public string Name;
        public DateTime ReqReceived;
        public DateTime ReqETA;
        public DateTime BIAETA;
        public string ReqSize;
        public string Stat;
        public decimal Percent;
        public DateTime CompDate;
        public string ReqResource;
        public string ReqGroup;
        public string Source;
        public string Description;

        public DBParameter[] DBParams()
        {
            DBParameter[] DBParams = {
                                         //must have the same name as the 'name' property
                                         new DBParameter("Manager", DbType.String, ReqManager),
                                         new DBParameter("Name", DbType.String, Name),
                                         new DBParameter("ReqReceived", DbType.DateTime, ReqReceived),
                                         new DBParameter("ReqETA", DbType.DateTime, ReqETA),
                                         new DBParameter("BIAETA", DbType.DateTime, BIAETA),
                                         new DBParameter("ReqSize", DbType.String, ReqSize),
                                         new DBParameter("Stat", DbType.String, Stat),
                                         new DBParameter("Percent", DbType.Decimal, Percent),
                                         new DBParameter("CompDate", DbType.DateTime, CompDate),
                                         new DBParameter("ReqResource", DbType.String, ReqResource),
                                         new DBParameter("ReqGroup", DbType.String, ReqGroup),
                                         new DBParameter("Source", DbType.String, Source),
                                         new DBParameter("Description", DbType.String, Description)
                                     };
            return DBParams;

        }
    }
}

