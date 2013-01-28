<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<ProductSearchResultPage>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <%
        var meta_description = "";
        var meta_keywords = "randonnées équestres,randonnée a cheval,randonnée équestre,randonnées a cheval,voyage a cheval, cavaliers,monde,tourisme équestre,randos, équitation,voyages, trekking,trek";
        var meta_title = "Caval&go - voyages inédits à cheval - Séjours et randonnées équestres en France et dans le monde";
        
        if ((Model.SelectedTagInfo != null) && (Model.SelectedTagInfo.cg_Products_Tags.Tag.ToLower() == "cheval"))
        {
            meta_description = "Randonnées à cheval, traditions équestres, stage équitation, tous les séjours et randonnées équestres pour cavaliers débutants ou confirmés de Caval&go - voyages inédits à cheval";
            meta_keywords = "randonnées équestres,randonnée a cheval,randonnée équestre,randonnées a cheval,voyage a cheval, cavaliers,monde,tourisme équestre,randos, équitation,voyages, trekking,trek";
            meta_title = "Randonnées à cheval, traditions équestres, stage équitation, tous les séjours et randonnées équestres de Caval&go - voyages inédits à cheval";
        }
        else if ((Model.SelectedTagInfo != null) && (Model.SelectedTagInfo.cg_Products_Tags.Tag.ToLower() == "autrement"))
        {
            meta_description = "Initiation équestre, randonnée pédestre, trekking, trek, tous les séjours et voyages sportifs pour les non-cavaliers de Caval&go - voyages inédits à cheval";
            meta_keywords = "randonnées équestres,randonnée a cheval,randonnée équestre,randonnées a cheval,voyage a cheval,cavaliers,monde,tourisme équestre,randos, équitation,voyages, trekking,trek";
            meta_title = "Initiation équestre, randonnée pédestre, trekking, trek, tous les séjours et voyages sportifs de Caval&go - voyages inédits à cheval";
        }
        else
        { 
            foreach (var activity in Model.Activities)
            {
                meta_description += activity.Name + ", ";
            }
        }
    %>
    <meta name="description" content="<%= meta_description %>" />
    <meta name="keywords" content="<%= meta_keywords %>" />
	<title><%= meta_title %></title>

    <link rel="icon" href="/content/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/content/images/favicon.ico" type="image/x-icon" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%
        caval_goEntities db = new caval_goEntities();
        
        string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;
        var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
        long defaultLanguageId = db.cg_Languages.Where(l => l.SystemLocale == defaultCulture).FirstOrDefault().LanguageId;

        // prepare filters
        string tagFilter = (string)ViewContext.RouteData.Values["tag"]; // Request.QueryString["tag"];
        string destFilter = Request.QueryString["destination"];
        string nameFilter = Request.QueryString["src_productName"];
        string codeFilter = Request.QueryString["src_productCode"];
        string departureFilter = Request.QueryString["dep"];

        
        // make list of select items for destinations
        var destinations = (
            from l in db.cg_Languages
            where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
            from d in db.cg_Destinations
            from di in d.cg_Destinations_Info
            where di.LanguageId == (d.cg_Destinations_Info.Where(inf => inf.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
            select new { 
                destName = di.cg_Destinations.Name, 
                destLanguageName = di.Name }
            ).Distinct().OrderBy(d => d.destLanguageName).ToList();
        
        SelectListItem viewAllDestinations = new SelectListItem();
        List<SelectListItem> destItems = new List<SelectListItem>();
        viewAllDestinations.Text = "- " + Caval_go.Controllers.cmsController.getLangVersion("Destination") + " -";
        viewAllDestinations.Value = "all";
        viewAllDestinations.Selected = destFilter == "" ? true : false;
        destItems.Add(viewAllDestinations);

        foreach (var destination in destinations)
        {
            SelectListItem item = new SelectListItem();
            item.Text = destination.destLanguageName;
            item.Value = destination.destName.ToLower();
            item.Selected = destFilter == item.Value ? true : false;

            destItems.Add(item);
        }
        
        // Departure dates
        List<SelectListItem> derpartureItems = new List<SelectListItem>();
        DateTime today = DateTime.Now;

        SelectListItem viewAllDepartures = new SelectListItem();
        viewAllDepartures.Text = "- " + Caval_go.Controllers.cmsController.getLangVersion("Départ") + " -";
        viewAllDepartures.Value = "all";
        viewAllDepartures.Selected = departureFilter == "" ? true : false;
        derpartureItems.Add(viewAllDepartures);
        
        for (int newMonth = 0; newMonth <= 12; newMonth++)
        {
            DateTime adjustedDate = today.AddMonths(newMonth);
            SelectListItem item = new SelectListItem();
            item.Text = adjustedDate.ToString("MMMM") + " " + adjustedDate.Year;
            item.Value = adjustedDate.ToShortDateString();
            item.Selected = departureFilter == item.Value ? true : false;

            derpartureItems.Add(item);
        }

                
        // Budget
        List<SelectListItem> budgetItems = new List<SelectListItem>();
        string budgetFilter = Request.QueryString["budget"];
        budgetItems.Add(new SelectListItem() { Text = "- " + Caval_go.Controllers.cmsController.getLangVersion("Budget") + " -", Value = "all", Selected = budgetFilter == "all" });
        budgetItems.Add(new SelectListItem() { Text = "jusqu'à 4500", Value = "4500", Selected = budgetFilter == "4500" });
        budgetItems.Add(new SelectListItem() { Text = "jusqu'à 3500", Value = "3500", Selected = budgetFilter == "3500" });
        budgetItems.Add(new SelectListItem() { Text = "jusqu'à 2500", Value = "2500", Selected = budgetFilter == "2500" });
        budgetItems.Add(new SelectListItem() { Text = "jusqu'à 1500", Value = "1500", Selected = budgetFilter == "1500" });

        // Selected destination
        cg_Activities_Info selectedActivity = new cg_Activities_Info();
        try
        {
            var activityId = Convert.ToInt64(Request.QueryString["activityId"]);
            selectedActivity = Model.Activities_All.Where(a => a.ActivityId == activityId).FirstOrDefault();
        }
        catch
        {
        }
        
    %>
        <!-- breadcrumbds -->
        <ul class="breadcrumbs">
            <li>
                <a href="/"><%= Caval_go.Controllers.cmsController.getLangVersion("Accueil")%></a>
            </li>
            <% if (Model.SelectedTagInfo != null) {%>
                <% if (selectedActivity != null)
                   {%>
                <li>
                    » <a href="/voyage/search/<%= ViewContext.RouteData.Values["tag"] %>"><%= Model.SelectedTagInfo.Name %></a>
                </li>
                <% } else { %>
                <li>
                    » <%= Model.SelectedTagInfo.Name %>
                </li>
                <% } %>
            <% } %>
            <% if (selectedActivity != null)
               {%>
            <li>
                » <%= selectedActivity.Name %>
            </li>
            <% } %>
        </ul>
        <!-- // breadcrumbds -->


    <!-- Top Part - Start -->
    <div class="2column-content">

        <div class="left-column-content">
            
            <ul class="search-top-left-filters">

            <% foreach (var activity in Model.Activities_All)
               {
                   string linkClass = "";
                   if ((selectedActivity != null) && (selectedActivity.ActivityId > 0))
                   {
                       linkClass = activity.ActivityId == selectedActivity.ActivityId ? "selected" : "";
                   }
                   try
                   {
            %>
                <li>
                    <%= Html.ActionLink(activity.Name, "search", new { tag = ViewContext.RouteData.Values["tag"], destination = String.Empty, activityId = activity.ActivityId }, new { @class = linkClass })%>
                </li>
            <% }
                   catch { }
               } %>
            </ul>

            <div class="sub-content">
                <%= Caval_go.Controllers.cmsController.getCmsBlockByName("Search_LeftColumn").Code%>
            </div>
            
            <div class="email-signup">
                <label for="email_signup">Newsletter: </label>
                <div id="msg_email_signup" style="color:#cc0000;"></div>
                <div class="email-fields">
                <input type="text" name="email_signup" id="email_signup" class="input-email" /> <input type="button" id="bt_email_signup" value="GO »" />
                </div>
            </div>

        </div>

        <div class="main-content">

            <div class="top-selection-content">
                <% if ((selectedActivity != null) && (selectedActivity.ActivityId > 0))
                   { %>
                <div>
                <% 
                    int loopCount = 0;
                    string itemClass = "show";
                    if (Model.SitePhotos != null)
                   {
                       if (loopCount > 0)
                           itemClass = "hidden";
                       %>
                       <ul class="quick-slideshow">
                       <%
                           foreach (var photo in Model.SitePhotos)
                           {
                       %>
                       <li class="<%= itemClass %>">
                        <img src="/img/view?path=/content/site-photos/<%= photo.SitePhotoId + photo.FileExtension %>&width=710&height=400" alt="<%= photo.AlternativeText %>" />
                       </li>
                   <% 
                       loopCount++;
                    } %>
                        </ul>
                <% } %>
                <h2><%= selectedActivity.Name%></h2>
                <%= selectedActivity.ShortDescription%>
                </div>
                <% } else {
                       if ((Model.SelectedTagInfo != null) && (!String.IsNullOrEmpty(Model.SelectedTagInfo.Description)))
                       {
                        Response.Write(Model.SelectedTagInfo.Description);
                    }
                    else
                    {
                        Response.Write(Caval_go.Controllers.cmsController.getCmsBlockByName("Search_Default").Code);
                    }
                } %>
            </div>

            <form id="product_search_form">
            <%= Html.Hidden("tag", tagFilter) %>
            <%= Html.Hidden("activityId", ((selectedActivity != null) && (selectedActivity.ActivityId > 0)) ? selectedActivity.ActivityId.ToString() : "")%>
            <table>
                <tr>
                    <td>
                        <%= Html.DropDownList("destination", destItems)%>
                    </td>
                    <td>
                        <%= Html.DropDownList("profile", Model.SearchEngineModel.profiles)%>
                    </td>
                    <td>
                        <%= Html.DropDownList("budget", budgetItems)%>
                    </td>
                    <td>
                        <%= Html.DropDownList("departure", derpartureItems)%>
                    </td>
                    <td>
                        <a href="javascript:;" onclick="$('#product_search_form').submit();" class="bt-general white-bg"><span>Rechercher »</span></a>
                    </td>
                </tr>
            </table>
            </form>

            <% Html.RenderPartial("searchresults", Model.Products); %>
        </div>

        <div class="clear"></div>
    
    </div>
    <!-- Top Part - End -->

</asp:Content>
