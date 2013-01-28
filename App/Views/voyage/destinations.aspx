<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<ProductSearchResultPage>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <%
    var meta_title = "Randonnées équestres en France et dans le monde, tous les voyages de Caval&go - voyages inédits à cheval";
    var meta_description = "Randonnées équestres en France et dans le monde, tous les voyages de Caval&go - voyages inédits à cheval";
    var meta_keywords = "randonnées équestres,randonnée a cheval,randonnée équestre,randonnées a cheval, voyage a cheval, cavaliers,monde,tourisme équestre,randos, équitation,voyages, trekking,trek";
    
    if (Model.SelectedDestination != null)
    {
        if (!String.IsNullOrEmpty(Model.SelectedDestination.MetaTitle)){
            meta_title = Model.SelectedDestination.MetaTitle;
        }
        if (!String.IsNullOrEmpty(Model.SelectedDestination.MetaDescription)){
            meta_description = Model.SelectedDestination.MetaDescription;
        }
        if (!String.IsNullOrEmpty(Model.SelectedDestination.MetaKeywords)){
            meta_keywords = Model.SelectedDestination.MetaKeywords;
        }
    }
    %>
	<title><%= meta_title %></title>

    <meta name="description" content="<%= meta_description %>" />
    <meta name="keywords" content="<%= meta_keywords %>" />

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
        string activityFilter = ViewContext.RouteData.Values["activityId"].ToString();
        string tagFilter = Request.QueryString["tag"];
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
            select new
            {
                destName = di.cg_Destinations.Name,
                destLanguageName = di.Name
            }
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

        
        // make list of select items for tags
        List<cg_Products_Tags> colTags = db.cg_Products_Tags.OrderBy(t => t.Tag).ToList();
        SelectListItem viewAllTags = new SelectListItem();
        List<SelectListItem> activityItems = new List<SelectListItem>();
        viewAllTags.Text = "- " + Caval_go.Controllers.cmsController.getLangVersion("Activité") + " -";
        viewAllTags.Value = "all";
        viewAllTags.Selected = activityFilter == "" ? true : false;
        activityItems.Add(viewAllTags);
        
        foreach (cg_Activities_Info activity in Model.Activities_All)
        {
            SelectListItem item = new SelectListItem();
            item.Text = activity.Name;
            item.Value = activity.ActivityId.ToString();
            item.Selected = activityFilter == activity.ActivityId.ToString() ? true : false;

            activityItems.Add(item);
        }

        
        // Departure dates
        List<SelectListItem> derpartureItems = new List<SelectListItem>();
        DateTime today = DateTime.Now;

        SelectListItem viewAllDepartures = new SelectListItem();
        viewAllDepartures.Text = "- " + Caval_go.Controllers.cmsController.getLangVersion("Départ") + " -";
        viewAllDepartures.Value = "all";
        viewAllDepartures.Selected = tagFilter == "" ? true : false;
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
        var selectedDestination = Model.SelectedDestination;
        
        string selectDestinationName = ViewContext.RouteData.Values["destination"].ToString().ToLower();
        bool isDestinationSelected = ((selectDestinationName != "all") && (!String.IsNullOrEmpty(selectDestinationName)));
        %>


        <!-- breadcrumbds -->
        <ul class="breadcrumbs">
            <li>
                <a href="/"><%= Caval_go.Controllers.cmsController.getLangVersion("Accueil")%></a>
            </li>
            <li>
                » <%= Caval_go.Controllers.cmsController.getLangVersion("Destinations")%>
            </li>
        </ul>
        <!-- // breadcrumbds -->

    <!-- Top Part - Start -->
    <div class="2column-content">

        <div class="left-column-content">
            
            <ul class="search-top-left-filters">

                <li>
                    <%= Html.ActionLink(Caval_go.Controllers.cmsController.getLangVersion("Toutes nos destinations"), "destinations", new { destination = "all", activityId = "all" }, new { @class = isDestinationSelected ? "" : "selected" })%>
                </li>
            <% foreach (var destination in Model.Destinations)
               {
                   string linkClass = "";
                   if ((selectedDestination != null) && (selectedDestination.DestinationId > 0))
                   {
                       linkClass = destination.Name.ToLower() == selectedDestination.Name.ToLower() ? "selected" : "";
                   }
                   try
                   {
            %>
                <li>
                    <%--<%= Html.ActionLink(destination.Name, "destinations", new { destination = destination.UrlCustomSegment.ToLower(), activityId = ViewContext.RouteData.Values["activityId"] }, new { @class = linkClass })%>--%>                    
                    <%= Html.ActionLink(destination.Name, "destinations", new { destination = destination.UrlCustomSegment.ToLower(), activityId = (decimal?)null }, new { @class = linkClass })%>
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
                <% if ((selectedDestination != null) && (selectedDestination.DestinationId > 0)) { %>
                <% if (Model.SitePhotos != null)
                   { %>
                       <ul class="quick-slideshow">
                       <%
                           int loopCount = 0;
                           string itemClass = "show";
                           foreach (var photo in Model.SitePhotos)
                           {
                               if (loopCount > 0)
                                   itemClass = "hidden";
                       %>
                       
                       <li class="<%= itemClass %>">
                        <img src="/img/view?path=/content/site-photos/<%= photo.SitePhotoId + photo.FileExtension %>&width=710&height=400" alt="<%= photo.AlternativeText %>" />
                       </li>
                       <% 
                            loopCount++;
                        } %>
                        </ul>
                <% } %>
                <h2><%= selectedDestination.Name %></h2>
                <div>
                <%= selectedDestination.ShortDescription %>
                </div>
                <% } else { %>
                    <%= Caval_go.Controllers.cmsController.getCmsBlockByName("Destination_Default").Code%>
                <% } %>
            </div>

            <form id="product_search_destinations_form">
            <%= Html.Hidden("destination", destFilter) %>
            <table>
                <tr>
                    <td>
                        <%= Html.DropDownList("activity", activityItems)%>
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
                        <a href="javascript:;" onclick="$('#product_search_destinations_form').submit();" class="bt-general white-bg"><span>Rechercher »</span></a>
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
