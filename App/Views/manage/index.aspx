<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Caval&go Back-Office</h2>
    
    <ul>
        <li>
            <a href="/manage/products">Produits</a>
        </li>
        <li>
            <a href="/manage/destinations">Destinations</a>
        </li>
        <li>
            <a href="/manage/activities">Activités</a>
        </li>
        <li>
            <a href="/manage/languages">Langues</a>
        </li>
        <li>
            <a href="/manage/tags">Tags</a>
        </li>
        <li>
            <a href="/manage/slideshows">Slideshows</a>
        </li>
        <li>
            <a href="/manage/translations">Traductions</a>
        </li>
        <li>
            Gestion de contenu
            <ul>
                <li><a href="/manage/cms_pages">Pages</a></li>
                <li><a href="/manage/cms_staticblocks">Blocks statiques</a></li>
                <li><a href="/manage/files">Gestion de fichiers</a></li>
            </ul>
        </li>
    </ul>

</asp:Content>
