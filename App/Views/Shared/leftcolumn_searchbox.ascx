<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<%
    Caval_go.Models.SearchEngine srcEngine = new Caval_go.Models.SearchEngine();
    var searchModel = srcEngine.getSearchModel();
%>

<div class="left-column moteur">
    <div class="content">
        <h3><%= Caval_go.Controllers.cmsController.getLangVersion("Cherchez votre voyage")%></h3>
        <form id="product_search_home_form">
            <%= Html.Hidden("tag", "") %>
            <%= Html.Hidden("activityId", "")%>
            <%= Html.DropDownList("destination", searchModel.destinations)%>
            <%= Html.DropDownList("profile", searchModel.profiles)%>
            <%= Html.DropDownList("departure", searchModel.departues)%>
            <%= Html.DropDownList("budget", searchModel.budgets)%>

            <a href="javascript:;" onclick="$('#product_search_home_form').submit();" class="bt-general white-bg"><span><%= Caval_go.Controllers.cmsController.getLangVersion("Rechercher")%> »</span></a>
        </form>
    </div>
</div>
