<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="barchart.aspx.cs" Inherits="chartdemo.barchart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="c3.css" rel="stylesheet" type="text/css" />

    <script src="d3.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="c3.js" type="text/javascript"></script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
      Here is what the dataset looks like in JSON format: <p />
      <%Response.Write(JSONDocument.ToString()); %>
    </div>
    <hr />
    <div>Here is an example using C3.js </p></div>
    <div id="bar_chart" style="width:450px" ></div>
    <div id="pie_chart" style="width:450px" ></div>
    <div id="gauge_chart" style="width:450px" ></div>
      <script>
          //dataObj = jQuery.ParseJSON(<%Response.Write(JSONDocument.ToString());%>);

          //alert(convertedData[0,1].toString());

          var barchart = c3.generate({
              bindto: '#bar_chart',
              data: {
                  json: <%Response.Write(JSONDocument.ToString());%>,
                  keys: {
                      x: 'Product',
                      value: ["This Year", "Last Year"],
                  },   
                  //columns: convertedData,
                  type: 'bar'
              },
              axis: {
                  x: {
                    type: 'category'
                  }
              },              
              legend: {
                position: 'right'
              },
              color: {
                  pattern: ['#1f77b4', '#aec7e8']
              }
          });

          var data = <%Response.Write(JSONDocument.ToString().Replace("This Year", "TY"));%>;
          var convertedData = [];

          data.forEach(function(item){
              convertedData.push([item.Product, item.TY]);
          });

          //alert(convertedData.length);

          var piechart = c3.generate({
              bindto: '#pie_chart',
              data: {
                  columns: convertedData,
                  type: 'pie'
              }
          });

          function calcGaugeData(product)
          {
              var sourceData = <%Response.Write(ForecastData.ToString());%>;
              var TYtotal = 0;
              var TYforecast = 0;
              sourceData.forEach(function(item){
                  TYtotal = item.TY + TYtotal;
                  TYforecast = item.Forecast + TYforecast;
              })

              var forecastPercentage = (TYtotal / TYforecast) * 100;
              //alert(forecastPercentage);

              var calculatedData = [];
              calculatedData.push(["All Products", forecastPercentage]);
              return calculatedData;
          }

          var ForecastDataSource = calcGaugeData("");

          var gaugechart = c3.generate({
              bindto: '#gauge_chart',
              data: {
                  columns: ForecastDataSource,
                  type: 'gauge'
              }
          });

      </script>
    </form>
</body>
</html>
