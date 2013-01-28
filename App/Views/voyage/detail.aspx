<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.ProductFullInfoByLanguage>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
    <%
        string productUrl = "";
        if (String.IsNullOrEmpty(Model.ProductInfo.UrlCustomSegment))
        {
            productUrl = "/voyage/detail/" + Model.ProductInfo.ProductId + "/" + Server.UrlEncode(Model.ProductInfo.Title.Trim('\"').Trim('\'').Trim().Replace("'", " ").Replace(" \"", "").Replace("\"", " ").Replace(":", " ").Replace(" - ", "-").Replace(", ", "-").Replace("/", " ").Replace("&", " ").Replace("   ", "-").Replace("  ", "-").Replace(" ", "-"));
        }
        else
        {
            productUrl = "/voyage/detail/" + Model.ProductInfo.ProductId + "/" + Server.UrlEncode(Model.ProductInfo.UrlCustomSegment);
        }

     %>
	<title><%= Model.ProductInfo.MetaTitle %></title>

    <link rel="canonical" href="<%= productUrl%>" />
    <link rel="icon" href="/content/images/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="/content/images/favicon.ico" type="image/x-icon" />

    <meta name="description" content="<%= Model.ProductInfo.MetaDescription %>" />
    <meta name="keywords" content="<%= Model.ProductInfo.MetaKeywords %>" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

        <!-- breadcrumbds -->
        <ul class="breadcrumbs">
            <li>
                <a href="/"><%= Caval_go.Controllers.cmsController.getLangVersion("Accueil")%></a>
            </li>
            <li>
                » <a href="/voyage/destinations/"><%= Caval_go.Controllers.cmsController.getLangVersion("Destinations")%></a>
            </li>
            <% if (Model.DestinationInfo != null) {%>
            <li>
                » <a href="/voyage/destinations/<%= Model.Destination.Name.ToLower() %>"><%= Model.DestinationInfo.Name%></a>
            </li>
            <% } %>
            <li>
                » <%= Model.ProductInfo.Title %>
            </li>
        </ul>
        <!-- // breadcrumbds -->

    <!-- Top Part - Start -->
    <div class="2column-content">

        <div class="left-column-content product-detail">

            <% Html.RenderPartial("leftcolumn_searchbox"); %>

            <ul class="search-top-left-filters">
                <li>
                    <h3><%= Model.DestinationInfo.Name %></h3>
                    <%= Html.ActionLink(Caval_go.Controllers.cmsController.getLangVersion("Tous les voyages") + ": " + Model.DestinationInfo.Name, "destinations", new { destination = Model.DestinationInfo.UrlCustomSegment.ToLower() })%>
                    <a href="/destination/<%= Model.DestinationInfo.UrlCustomSegment.ToLower() %>"><%= Caval_go.Controllers.cmsController.getLangVersion("Plus d'infos") %>: <%= Model.DestinationInfo.Name %></a>
                </li>
            </ul>


            <ul class="search-top-left-filters">
                <li>
                    <h3><%= Caval_go.Controllers.cmsController.getLangVersion("Infos activité")%></h3>
                </li>
                <% foreach(var activity in Model.Activities) { %>
                <li>
                    <%= Html.ActionLink(activity.Name, "search", new { activityId = activity.ActivityId })%>
                </li>
                <% } %>
            </ul>

            <%
                string bookLink = "#product_tab_dates";

                if (Model.Product.AllYearRound == true)
                {
                    bookLink = "/voyage/book/" + Model.Product.ProductId;
                }
            %>
            
            <div>
            <a href="<%= bookLink %>"<img src="/Content/images/banner-book-gnl.png" /></a>
            </div>
            <br />
            
            <div>
            <a href="/cms/inscription"<img src="/Content/images/banner-comment-inscrire.png" /></a>
            </div>
            <br />

            <% if (!String.IsNullOrEmpty(Model.ProductInfo.ProductSummary)){ %>
            <div class="prod-summary">
                <%= Model.ProductInfo.ProductSummary %>
            </div>
            <% } %>

            <div class="all-destination-products">
                <h3><%= Model.DestinationInfo.Name %> - <%= Caval_go.Controllers.cmsController.getLangVersion("Autres voyages") %></h3>
                <ul class="search-top-left-filters">
                <% foreach(var trip in Model.DestinationProducts) {
                        string linkClass = "";
                        linkClass = trip.Product.ProductId == Model.Product.ProductId ? "selected" : "";

                        string productUrl = "";
                        if (String.IsNullOrEmpty(trip.ProductInfo.UrlCustomSegment))
                        {
                            productUrl = "/voyage/detail/" + trip.Product.ProductId + "/" + Server.UrlEncode(trip.ProductInfo.Title.ToLower().Trim('\"').Trim('\'').Trim().Replace("'", " ").Replace(" \"", "").Replace("\"", " ").Replace(":", " ").Replace(" - ", "-").Replace(", ", "-").Replace("/", " ").Replace("&", " ").Replace("   ", "-").Replace("  ", "-").Replace(" ", "-"));
                        }
                        else
                        {
                            productUrl = "/voyage/detail/" + trip.Product.ProductId + "/" + Server.UrlEncode(trip.ProductInfo.UrlCustomSegment.ToLower());
                        }
                       %>
                    <li>
                        <a href="<%= productUrl %>" class="<%= linkClass %>"><%= trip.ProductInfo.Title %></a>
                    </li>
                <% } %>
                </ul>
            </div>

            <img class="destination-quickmap" src="http://maps.google.com/maps/api/staticmap?center=<%= Model.Destination.MapAddress %>&zoom=4&size=216x218&sensor=false" />

            <div class="lower-left-col">
                <%= Model.ProductInfo.CustomField1 %>
            </div>

            
            <div class="email-signup">
                <label for="email_signup">Newsletter: </label>
                <div id="msg_email_signup" style="color:#cc0000;"></div>
                <div class="email-fields">
                <input type="text" name="email_signup" id="email_signup" class="input-email" /> <input type="button" id="bt_email_signup" value="GO »" />
                </div>
            </div>


        </div>

        <div class="main-content product-detail">
            
            <% if (Model.Photos.Count() > 0) { %>
            <div class="product-detail-images">
                <div class="full-view">
                    <img src="/img/view?path=/content/trip-photos/<%= Model.Photos.FirstOrDefault().ProductPhotoId + Model.Photos.FirstOrDefault().FileExtension %>&width=710&height=500" alt="<%= Model.Photos.FirstOrDefault().Description %>" style="/*max-width: 400px; max-height: 300px;*/" />
                </div>
                <div class="thumbs">
                    <% foreach (var item in Model.Photos) { %>
                    <span class="product-thumb" onclick="loadTripImg('<%= item.ProductPhotoId + item.FileExtension %>', this);">
                        <img src="/img/view?path=/content/trip-photos/<%= item.ProductPhotoId + item.FileExtension %>&width=80&height=60" alt="<%= item.Description %>" style="max-width: 80px; max-height: 60px;" />
                    </span>
    
                    <% } %>
                </div>
                <div class="clear"></div>
            </div>

            <% } %>

            <h2><%= Model.ProductInfo.Title %></h2>

            <div class="description">
                <%= Model.ProductInfo.Description %>

            </div>

            <div id="product_tabs">
                <ul>
                    <li><a href="#product_tab_dates"><span><%= Caval_go.Controllers.cmsController.getLangVersion("Départs & tarifs")%></span></a></li>
                    <% foreach (var tab in Model.Tabs) { %>
                    <li><a href="#product_tab_<%= tab.ProductInfoTabId %>"><span><%= tab.TabTitle %></span></a></li>
                    <% } %>
                </ul>

                <!-- dates table -->
                <div id="product_tab_dates"">
                    
                    <% if (Model.Product.AllYearRound == true) { %>
                        <a href="/voyage/book/<%= Model.Product.ProductId %>" class="bt-general white-bg"><span><%= Caval_go.Controllers.cmsController.getLangVersion("Réservation") %> »</span></a>
                    <% } %>

                    <% if (Model.Dates.Count() > 0) { %>
                    <table class="full-width list">
                        <tr>
                            <th>
                                <%= Caval_go.Controllers.cmsController.getLangVersion("Départ") %>
                            </th>
                            <th>
                                <%= Caval_go.Controllers.cmsController.getLangVersion("Prix") %>
                            </th>
                            <th>
                                <%= Caval_go.Controllers.cmsController.getLangVersion("Vol à partir de") %>
                            </th>
                            <th>
                                <%= Caval_go.Controllers.cmsController.getLangVersion("Mini pers.") %>
                            </th>
                            <th></th>
                        </tr>

                    <% foreach (var item in Model.Dates) { %>
    
                        <tr>
                            <td>
                                <%= Html.Encode(item.DepartureDate.ToShortDateString())%>
                                 - 
                                <%= Html.Encode(item.ReturnDate.ToShortDateString()) %>
                           </td>
                            <td>
                                <%= String.Format("{0:###,##0 €}", item.Price)%>
                           </td>
                            <td>
                                <%= String.Format("{0:###,##0 €}", item.FlightPrice)%>
                           </td>
                            <td>
                                <%= Html.Encode(item.MiniPersons) %>
                           </td>
                           <td>
                           <a href="/voyage/book/<%= Model.Product.ProductId + "?dep=" + Server.UrlEncode(item.DepartureDate.ToShortDateString()) %>" class="bt-general white-bg"><span><%= Caval_go.Controllers.cmsController.getLangVersion("Réserver") %> »</span></a>
                           </td>
                        </tr>
    
                    <% } %>

                    </table>
                    <% } %>

                    <div class="pricing-info">
                        <%= Model.ProductInfo.PricingInfo %>
                    </div>
                </div>
                <% foreach (var tab in Model.Tabs) { %>
                <div id="product_tab_<%= tab.ProductInfoTabId %>"">
                    <%= tab.TabCode %>
                </div>
                <% } %>

            </div>
        </div>

        <div class="clear"></div>
    
    </div>
    <!-- Top Part - End -->

</asp:Content>
