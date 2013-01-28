<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/site_2column_left.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Destinations_Info>" %>

<asp:Content ID="Content3" ContentPlaceHolderID="cphHead" runat="server">
    <title>Infos Pays - <%= Model.Name %></title>

    <link rel="icon" href="/content/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/content/images/favicon.ico" type="image/x-icon" />

    <meta name="description" content="<%= Model.MetaDescription %>" />
    <meta name="keywords" content="<%= Model.MetaKeywords %>" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%= Model.Name %></h2>

    <%= Model.Description %>

</asp:Content>
