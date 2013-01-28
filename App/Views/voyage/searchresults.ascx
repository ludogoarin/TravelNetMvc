<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<Caval_go.Models.ProductSearchResult>>" %>
<%@ Import Namespace="Caval_go.Models" %>

    <%
        if (Model.Count() > 0)
        {
            using (var db = new caval_goEntities())
            {
    %>

    <%
                string orderBy = "price";
                if (Request.QueryString["sort"] != null)
                {
                    orderBy = Request.QueryString["sort"];
                }

                string currentAction = ViewContext.RouteData.Values["action"].ToString();
                long activityId = 0;
                if ((currentAction == "search") && (!String.IsNullOrEmpty(Request.QueryString["activityId"])))
                {
                    activityId = Convert.ToInt64(Request.QueryString["activityId"]);
                }
                else if ((currentAction == "destinations") && (ViewContext.RouteData.Values["activityId"] != null))
                {
                    long.TryParse(ViewContext.RouteData.Values["activityId"].ToString(), out activityId);
                }

                var destination = ViewContext.RouteData.Values["destination"].ToString();
                if (String.IsNullOrEmpty(destination)) destination = "all";
        
    %>

    <div class="product-results-sort">
        <%= Caval_go.Controllers.cmsController.getLangVersion("Ordonner par")%>: 

    <% if (orderBy == "price")
       { %>
        <%= Caval_go.Controllers.cmsController.getLangVersion("prix")%> | 
        <%= Html.ActionLink(Caval_go.Controllers.cmsController.getLangVersion("date"), currentAction, new { tag = ViewContext.RouteData.Values["tag"], destination = destination, activityId = activityId, sort = "date", budget = Request.QueryString["budget"], dep = Request.QueryString["dep"] })%>
    <% }
       else
       { %>
        <%= Html.ActionLink(Caval_go.Controllers.cmsController.getLangVersion("prix"), currentAction, new { tag = ViewContext.RouteData.Values["tag"], destination = destination, activityId = activityId, sort = "price", budget = Request.QueryString["budget"], dep = Request.QueryString["dep"] })%>
         | date
    <% } %>
    </div>
    <table class="full-width search">
        <tr>
            <th></th>
            <th>
                <%= Caval_go.Controllers.cmsController.getLangVersion("Voyage")%>
            </th>
            <th>
                <%= Caval_go.Controllers.cmsController.getLangVersion("Infos Départ")%>
            </th>
        </tr>

    <%
string priceFrom = Caval_go.Controllers.cmsController.getLangVersion("A partir de");
string departuresGuaranteedAllYear = Caval_go.Controllers.cmsController.getLangVersion("Départs garantis toute l'année");
string nextDeparture = Caval_go.Controllers.cmsController.getLangVersion("Prochain départ");
string taxIncluded = Caval_go.Controllers.cmsController.getLangVersion("TTC");
string unitDays = Caval_go.Controllers.cmsController.getLangVersion("jours");

int loopCount = 0;
foreach (var item in Model)
{
    loopCount++;
    string productUrl = "";
    if (String.IsNullOrEmpty(item.ProductInfo.UrlCustomSegment))
    {
        productUrl = "/voyage/detail/" + item.Product.ProductId + "/" + Server.UrlEncode(item.ProductInfo.Title.ToLower().Trim('\"').Trim('\'').Trim().Replace("'", " ").Replace(" \"", "").Replace("\"", " ").Replace(":", " ").Replace(" - ", "-").Replace(", ", "-").Replace("/", " ").Replace("&", " ").Replace("   ", "-").Replace("  ", "-").Replace(" ", "-"));
    }
    else
    {
        productUrl = "/voyage/detail/" + item.Product.ProductId + "/" + Server.UrlEncode(item.ProductInfo.UrlCustomSegment.ToLower());
    }
        %>
    
        <tr class="search-result-row <%= loopCount % 2 == 0 ? "even" : "odd" %>">
            <td class="photo">
            <a href="<%= productUrl %>">
                <%
    var photoFilename = "no-photo.png";
    if (item.FirstPhoto != null)
    {
        photoFilename = item.FirstPhoto.ProductPhotoId + item.FirstPhoto.FileExtension;
    }
                %>
                <img src="/img/view?path=/content/trip-photos/<%= photoFilename %>&width=140&height=140" style="max-width: 140px; max-height: 140px;" />
                </a>
            </td>
            <td class="descriptive">
                <a href="<%= productUrl %>">
                <h3><%= Html.Encode(item.ProductInfo.Title)%></h3>
                <div class="tags">
                <% 
string tagSeperator = "";
foreach (var tag in item.TagsMap)
{
    cg_Products_Tags_Info pti = db.cg_Products_Tags_Info.Where(ti => ti.ProductTagId == tag.ProductTagId).FirstOrDefault();
    if (pti != null)
    {
        Response.Write(tagSeperator + pti.Name);
        tagSeperator = " / ";
    }
} %>
                </div>
                <%= item.ProductInfo.ShortDescription%>
                </a>
            </td>
            <td class="figures">
                <span class="duration"><%= Html.Encode(item.Duration)%> <%= unitDays%></span>
                    <br />
               <% if (item.AllYearRound == 1)
                  {
                      var price = item.Product.Price;
                       %>
                    <%= priceFrom%> <span class="price"><%= String.Format("{0:###,##0 €}", price) + " " + taxIncluded%></span>
                    <br />
                    <span class="highlight"><%= departuresGuaranteedAllYear%></span>
                <% }
                  else
                  {
                      var price = item.CheapestDate.Price;
                       %>
                    <%= priceFrom%> <span class="price"><%= String.Format("{0:###,##0 €}", price) + " " + taxIncluded%></span>
                    <br />
                    <%= nextDeparture%>: <%= item.FirstDate.DepartureDate.ToShortDateString()%>
                <% } %>
            </td>
        </tr>
    
    <% } %>

    </table>

    <%      }
        }
        else
        {
    %>
    <div class="no-results">
        <%= Caval_go.Controllers.cmsController.getCmsBlockByName("NoResults").Code %>
    </div>
    <%      
        }
     %>