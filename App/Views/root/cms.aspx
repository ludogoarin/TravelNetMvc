<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/site_2column_left.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_cms_Pages_Info>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <title><%= Model.Tag_Title %></title>

    <link rel="icon" href="/content/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/content/images/favicon.ico" type="image/x-icon" />

    <meta name="description" content="<%= Model.Tag_Description %>" />
    <meta name="keywords" content="<%= Model.Tag_Keywords %>" />   
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="cphBreadcrumbs" runat="server">

    <!-- breadcrumbds -->
    <ul class="breadcrumbs">
        <li>
            <a href="/"><%= Caval_go.Controllers.cmsController.getLangVersion("Accueil")%></a>
        </li>
        <li>
            » <%= Model.Name %>
        </li>
    </ul>
    <!-- // breadcrumbds -->

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%= Model.Code %>

</asp:Content>
