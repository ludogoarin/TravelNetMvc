<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.SearchEngineModel>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <title>Caval&go - voyages inédits à cheval - Séjours et randonnées équestres en France et dans le monde</title>

    <link rel="icon" href="/content/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/content/images/favicon.ico" type="image/x-icon" />

    <meta name="description" content="L'émotion du voyage à cheval et de la randonnée équestre en France et dans le monde (Maroc, Mongolie, Jordanie, Argentine, Équateur, Irlande...). Randonnées à cheval, stages équitation, week-end équestres pour cavaliers confirmés à débutants." />
    <meta name="keywords" content="randonnées équestres,randonnée a cheval,randonnée équestre,randonnées a cheval,voyage a cheval, cavaliers,monde,tourisme équestre,randos, équitation,voyages, trekking,trek" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div id="home_slideshow">
        <ul class="slides">
            <%
                int loopCount = 0;
                string itemClass = "";
                foreach(var slide in Model.slideshow.Slides) {
                    if (loopCount > 0)
                        itemClass = "hidden";
            %>
            <li class="<%= itemClass %>">
                <% if (String.IsNullOrEmpty(slide.Link)) { %>
                <img src="/content/site-photos/<%= slide.SitePhotoId + slide.FileExtension %>" alt="<%= slide.AlternativeText %>" />
                    <% if (!String.IsNullOrEmpty(slide.Description)) { %>
                    <div class="textover">
                        <%= slide.Description %>
                    </div>
                    <% } %>
                <% } else { %>
                <a href="<%= slide.Link %>">
                    <img src="/content/site-photos/<%= slide.SitePhotoId + slide.FileExtension %>" alt="<%= slide.AlternativeText %>" />
                    <% if (!String.IsNullOrEmpty(slide.Description)) { %>
                    <div class="textover">
                        <%= slide.Description %>
                    </div>
                    <% } %>
                </a>
                <% } %>
            </li>
            <%
                    loopCount++;
                } %>
        </ul>
        <div class="clear"></div>
        <div class="pager">
            <div class="pages">
            </div>
            <div class="cursor">
                <a href="javascript:;" class="previous">précédente</a> 
                <a href="javascript:;" class="next">prochaine</a>
            </div>
            <div class="clear"></div>
        </div>
        <div class="clear"></div>
    </div>

    <div class="home">

        <!-- Home Page 3 Columns -->
        <div class="mid-columns">
            <!-- 1 - Moteur de recherche -->
            <div class="middle-column moteur">
                <h3><%= Caval_go.Controllers.cmsController.getLangVersion("Cherchez votre voyage")%></h3>
                <div class="content">
                    <form id="product_search_home_form">
                        <%= Html.Hidden("tag", "") %>
                        <%= Html.Hidden("activityId", "")%>
                        <%= Html.DropDownList("destination", Model.destinations)%>
                        <%= Html.DropDownList("profile", Model.profiles)%>
                        <%= Html.DropDownList("departure", Model.departues)%>
                        <%= Html.DropDownList("budget", Model.budgets)%>

                        <a href="javascript:;" onclick="$('#product_search_home_form').submit();" class="bt-general"><span><%= Caval_go.Controllers.cmsController.getLangVersion("Rechercher")%> »</span></a>
                    </form>
                </div>
            </div>

            <!-- 2 - Mise en avant #1 -->
            <div class="middle-column mea1">
                <div class="content">
                    <%= Caval_go.Controllers.cmsController.getCmsBlockByName("MEA_1").Code%>
                </div>
            </div>

            <!-- 2 - Mise en avant #2 -->
            <div class="middle-column mea2">
                <div class="content">
                    <%= Caval_go.Controllers.cmsController.getCmsBlockByName("MEA_2").Code%>
                </div>
            </div>

            <div class="clear"></div>
        </div>

        <!-- Block texte -->
        <div class="text-over-grey">
            <%= Caval_go.Controllers.cmsController.getCmsBlockByName("AccueilTexteMilieu").Code%>
        </div>

    </div>
</asp:Content>
