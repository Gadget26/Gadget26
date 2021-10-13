using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

using BIACore.Model;
using BIACore.Security;
using extjs = BIACore.Web.Model.ExtJS;

using Newtonsoft.Json;

namespace DataRequest.WebAPI.Model
{//must customerize
//to add new filter simply copy the and and add the row & input the data
    public class Filter : extjs.Parameter
    {

        //public string sysm { get; set; }
        //public string Ad_Id { get; set; }
        //public string Emp_Id { get; set; }
        //public string Department { get; set; }
        //public string JobLevel { get; set; }

        public string Division_Manager { get; set; }
        public string Requestor { get; set; }
        //public string Date_Request_Received { get; set; }
        //public string Requested_ETA { get; set; }
        //public string BIA_Provided_ETA { get; set; }
        //public string Completion_Date { get; set; }
        public string DataSize { get; set; }
        public string Status { get; set; }
        public string BIA_Resource { get; set; }
        public string ReqGroup { get; set; }
        public string Source { get; set; }

        public Filter() { }

        public override DBParameter[] ToDBParameter()
        {

            //Sane_Sort();

            List<DBParameter> args = new List<DBParameter>();

            if (!string.IsNullOrEmpty(Division_Manager)) args.Add(new DBParameter("@Division_Manager", DbType.AnsiString, Division_Manager));
            if (!string.IsNullOrEmpty(Requestor)) args.Add(new DBParameter("@Requestor", DbType.AnsiString, Requestor));
            //if (!string.IsNullOrEmpty(Date_Request_Received)) args.Add(new DBParameter("@Date_Request_Received", DbType.AnsiString, Date_Request_Received));
            //if (!string.IsNullOrEmpty(Requested_ETA)) args.Add(new DBParameter("@Requested_ETA", DbType.AnsiString, Requested_ETA));
            //if (!string.IsNullOrEmpty(BIA_Provided_ETA)) args.Add(new DBParameter("@BIA_Provided_ETA", DbType.AnsiString, BIA_Provided_ETA));
            //if (!string.IsNullOrEmpty(Completion_Date)) args.Add(new DBParameter("@Completion_Date", DbType.AnsiString, Completion_Date));
            if (!string.IsNullOrEmpty(DataSize)) args.Add(new DBParameter("@DataSize", DbType.AnsiString, DataSize));
            if (!string.IsNullOrEmpty(Status)) args.Add(new DBParameter("@Status", DbType.AnsiString, Status));
            if (!string.IsNullOrEmpty(BIA_Resource)) args.Add(new DBParameter("@BIA_Resource", DbType.AnsiString, BIA_Resource));
            if (!string.IsNullOrEmpty(ReqGroup)) args.Add(new DBParameter("@ReqGroup", DbType.AnsiString, ReqGroup));
            if (!string.IsNullOrEmpty(Source)) args.Add(new DBParameter("@Source", DbType.AnsiString, Source));

            args.AddRange(base.ToDBParameter());

            return args.ToArray();
        }


        //private void Sane_Sort()
        //{
        //    if (null == sort || sort.Length == 0) return;

        //    // if it's null or false, remove it from the list.
        //    List<extjs.Sorter> Sort = new List<extjs.Sorter>(sort);

        //    Sort = Sort.Where(x => x.property != "sysm").ToList();

        //    //if (null == ShowMonth || !ShowMonth.Value) Sort = Sort.Where(x => x.property != "sysm").ToList();

        //    sort = Sort.ToArray();
        //}

    }
}
