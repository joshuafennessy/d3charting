﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Odbc;
using Newtonsoft.Json;


//in this webpage I'll need to connect to some data in SQL Server and 
//serialize it as a JSON object so we can connect it up with the D3.js script

namespace chartdemo
{
    public partial class barchart : System.Web.UI.Page
    {

        public string JSONDocument;
        public string ForecastData;

        protected void Page_Load(object sender, EventArgs e)
        {
            acquireData();
        }

        private void acquireData()
        {
               OdbcConnection conn = new OdbcConnection("Driver={SQL Server Native Client 11.0}; server=jfsql2014;database=d3charting;trusted_connection=yes;");
               OdbcCommand cmd = new OdbcCommand("select * from bar_chart;");

               conn.Open();
               cmd.Connection = conn;

               OdbcDataAdapter da = new OdbcDataAdapter();
               System.Data.DataSet ds = new System.Data.DataSet();
               da.SelectCommand = cmd;
               da.Fill(ds);

               JSONDocument = JsonConvert.SerializeObject(ds.Tables[0], Formatting.None);

               cmd = new OdbcCommand("select T.Product, T.[This Year] as TY, F.Forecast FROM bar_chart T JOIN forecast F ON T.Product = F.Product");
               cmd.Connection = conn;
               da = new OdbcDataAdapter();
               ds = new System.Data.DataSet();
               da.SelectCommand = cmd;
               da.Fill(ds);

               ForecastData = JsonConvert.SerializeObject(ds.Tables[0], Formatting.None);

               conn.Close();
               
        }
    }
 
}