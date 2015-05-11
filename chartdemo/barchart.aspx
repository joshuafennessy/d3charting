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
    <div style="font-family:Verdana">
      Here is what the dataset looks like in JSON format: <p />
      <%Response.Write(JSONDocument.ToString()); %>
    </div>
    <hr />
    <div style="font-family:Verdana">Here is an example using C3.js </div>
    <div id="bar_chart" style="width:450px" ></div>
    
    <table style="width:900px">
    <tr>
     <td>
     <div style="font-family:Verdana;width:450px;float:left">Go ahead, click me.  You know you want to. Just one slice.</div>
     <div id="pie_chart" style="width:450px;float:left" ></div>
     </td>
     <td style="vertical-align:top">
     <div style="font-family:Verdana;width:450px;align-content:center" id="ForecastLabel"></div>
     <div id="gauge_chart" style="width:450px;float:right" ></div>
     </td>
     </tr>
    </table>
    
          <script>
          //dataObj = jQuery.ParseJSON(<%Response.Write(JSONDocument.ToString());%>);

          //alert(convertedData[0,1].toString());

          function getLastSlice(){
              document.getElementById("ForecastLabel").innerHTML = "Forecast performance for Product: " + lastSlice;
          }

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
                  type: 'pie',
                  onclick: function(d, i) {updateGauge(d.id);} //d.id returns the product name in this example -- good luck finding that in the docs
              }
          });

          var lastSlice = "All"
          function calcGaugeData(product)
          {
              var sourceData = <%Response.Write(ForecastData.ToString());%>;
              var TYtotal = 0;
              var TYforecast = 0;


              if (lastSlice != "All" && (lastSlice == product))
              { // then we've clicked the same slice again, so clear filters
                  product = "All";
              }

              //alert(product);
              if (product == "All"){
                  //alert("In the all branch");
                  sourceData.forEach(function(item){
                      TYtotal = item.TY + TYtotal;
                      TYforecast = item.Forecast + TYforecast;
                  })

                  var forecastPercentage = (TYtotal / TYforecast) * 100;
                  //alert(forecastPercentage);

                  var calculatedData = [];
                  calculatedData.push(["All Products", forecastPercentage]);
              }
              else
              {
                  //alert("In the else branch");
                  sourceData.forEach(function(item){
                      if (product == item.Product){
                          //alert("found a match " + product + ", " + item.Product );
                          TYtotal = item.TY + TYtotal;
                          TYforecast = item.Forecast + TYforecast;
                          //alert(TYtotal);
                          //alert(TYforecast);
                      }
                  })

                  var forecastPercentage2 = (TYtotal / TYforecast) * 100;
                  //alert(forecastPercentage2);

                  var calculatedData = [];
                  calculatedData.push(["All Products", forecastPercentage2]);
                  
              }
              lastSlice = product;
              getLastSlice();
              return calculatedData;
          }

          function updateGauge(product)
          {
              //alert(product);
              var ForecastDataSource2 = calcGaugeData(product);

              //gaugechart.unload({});
              gaugechart.load({
                  columns: ForecastDataSource2
              });
              //gaugechart.load({});
          }

          var ForecastDataSource = calcGaugeData("All");

          var gaugechart = c3.generate({
              bindto: '#gauge_chart',
              data: {
                  columns: ForecastDataSource,
                  type: 'gauge'
              },
              color: {
                  pattern: ['#FF0000', '#F97600', '#F6C600', '#60B044'], 
                  threshold: {
                      values: [30, 60, 90, 100]
                  }
              }             
          });

      </script>
    </form>
</body>
</html>
