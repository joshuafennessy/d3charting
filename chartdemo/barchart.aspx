<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="barchart.aspx.cs" Inherits="chartdemo.barchart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="c3.css" rel="stylesheet" type="html/sandboxed" />

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
    <div id="chart" style="width:450px">
    Here is an example using C3.js </p>
      <script>
          //dataObj = jQuery.ParseJSON(<%Response.Write(JSONDocument.ToString());%>);
          <%--var data = <%Response.Write(JSONDocument.ToString());%>;
          var convertedData = [];

          data.forEach(function(item){
              convertedData.push([item.name], item.value1);
          });--%>

          var barchart = c3.generate({
              bindto: '#chart',
              data: {
                  json: <%Response.Write(JSONDocument.ToString());%>,
                  keys: {
                      x: 'name',
                      value: ["value1", "value2"],
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
              }
          });
      </script>
    </div>
    </form>
</body>
</html>
