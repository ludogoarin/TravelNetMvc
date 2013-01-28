<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>DASHBOARD</h2>
    
    <ul>
        <li><%= Html.ActionLink("Reserve Class Start Times", "select_class", "book")%></li>
    </ul>

</asp:Content>
