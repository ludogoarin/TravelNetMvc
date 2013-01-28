<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/site_2column_left.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.ProductBookingPageInfo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
	<title><%= Caval_go.Controllers.cmsController.getLangVersion("Réservation") %></title>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="cphBreadcrumbs" runat="server">

        <% bool isProductSelected = ViewContext.RouteData.Values["id"] != null; %>

        <!-- breadcrumbds -->
        <ul class="breadcrumbs">
            <li>
                <a href="/"><%= Caval_go.Controllers.cmsController.getLangVersion("Accueil")%></a>
            </li>
            <li>
                » <a href="/voyage/destinations/"><%= Caval_go.Controllers.cmsController.getLangVersion("Destinations")%></a>
            </li>
            <% if (isProductSelected)
               { %>
            <% if (Model.ProductFullInfoLang.DestinationInfo.Name != null) {%>
            <li>
                » <a href="/voyage/destinations/<%= Model.ProductFullInfoLang.DestinationInfo.Name.ToLower() %>"><%= Model.ProductFullInfoLang.DestinationInfo.Name%></a>
            </li>
            <% }
            string productUrl = "/voyage/detail/" + Model.ProductFullInfoLang.Product.ProductId + "/" + Server.UrlEncode(Model.ProductFullInfoLang.ProductInfo.Title.Trim('\"').Trim('\'').Trim().Replace("'", " ").Replace(" \"", "").Replace("\"", " ").Replace(":", " ").Replace(" - ", "-").Replace(", ", "-").Replace("/", " ").Replace("&", " ").Replace("   ", "-").Replace("  ", "-").Replace(" ", "-"));
                %>
            <li>
                » <a href="<%= productUrl %>"><%= Model.ProductFullInfoLang.ProductInfo.Title%></a>
            </li>
            <% } %>
            <li>
                » <%= Caval_go.Controllers.cmsController.getLangVersion("Réservation")%>
            </li>
        </ul>
        <!-- // breadcrumbds -->

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <% bool isProductSelected = ViewContext.RouteData.Values["id"] != null;
       var selectedDate = new Caval_go.Models.cg_Products_Dates();

       if (isProductSelected)
       {
           foreach (var date in Model.DepartureDates)
           {
               date.Selected = date.Value == Request.QueryString["dep"];
           }

           selectedDate = Model.ProductFullInfoLang.Dates.Where(d => d.DepartureDate.ToShortDateString() == Request.QueryString["dep"]).FirstOrDefault();
       }
    %>


    <div class="book">
    <%= Caval_go.Controllers.cmsController.getCmsBlockByName("Devis_Haut").Code%>

    <form action="/message/sendEmailForm" method="post" id="form_book_trip">
        <%= Html.ValidationSummary(true)%>
        
        <% if (isProductSelected) { %>
        <fieldset>
            <legend><%= Caval_go.Controllers.cmsController.getLangVersion("Votre voyage") %></legend>

            <table>
                <tr>
                    <td>
                        <%
                        var photoFilename = "no-photo.png";
                        var firstPhoto = Model.ProductFullInfoLang.Photos.FirstOrDefault();
                        if (firstPhoto != null)
                        {
                            photoFilename = firstPhoto.ProductPhotoId + firstPhoto.FileExtension;
                        }
                        %>
                        <img src="/img/view?path=/content/trip-photos/<%= photoFilename %>&width=140&height=80" style="margin: 0 10px 0 0;" />
                    </td>
                    <td>
                        <strong><%= Model.ProductFullInfoLang.ProductInfo.Title%></strong>
                        <div>
                        <%= Model.ProductFullInfoLang.ProductInfo.ShortDescription%>
                        </div>
                        <% if (Model.ProductFullInfoLang.Product.AllYearRound != true)
                           { %>
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
                            </tr>    
                            <tr>
                                <td>
                                    <%= Html.Encode(selectedDate.DepartureDate.ToShortDateString())%>
                                     - 
                                    <%= Html.Encode(selectedDate.ReturnDate.ToShortDateString())%>
                               </td>
                                <td>
                                    <%= String.Format("{0:###,##0 €}", selectedDate.Price)%>
                               </td>
                                <td>
                                    <%= String.Format("{0:###,##0 €}", selectedDate.FlightPrice)%>
                               </td>
                                <td>
                                    <%= Html.Encode(selectedDate.MiniPersons)%>
                               </td>
                            </tr>

                        </table>
                        <% }
                           else
                           { %>
                        <strong><%= Caval_go.Controllers.cmsController.getLangVersion("A partir de") %> <%= String.Format("{0:###,##0 €}", Model.ProductFullInfoLang.Product.Price)%></strong>
                        <% } %>
                    </td>
                </tr>
            </table>
        </fieldset>
        <% } %>

        <fieldset>
            <legend><%= Caval_go.Controllers.cmsController.getLangVersion("Formulaire") %></legend>
            <% if (isProductSelected) { %>
            <%= Html.Hidden("ProductCode", Model.ProductFullInfoLang.Product.ProductCode)%>
            <% } else { %>
            <%= Html.Hidden("ProductCode", "NO SELECTION")%>
            <% } %>
            <table class="contact_fields">
                <tr>
                    <td colspan="3"><h3><%= Caval_go.Controllers.cmsController.getLangVersion("Votre projet") %></h3></td>
                </tr>
                <tr>
                    <td>
                        <label for="if_date_depart"><%= Caval_go.Controllers.cmsController.getLangVersion("Date départ") %>:</label>
                        <% if ((!isProductSelected) || (Model.ProductFullInfoLang.Product.AllYearRound == true))
                           { %>
                        <input type="text" name="date_depart" id="if_date_depart" class="datepicker required" />
                        <% }
                           else
                           { %>
                        <%--<%= Html.DropDownList("Departure", Model.DepartureDates)%>--%>
                        <%= Html.Hidden("date_depart", selectedDate.DepartureDate.ToShortDateString())%>
                        <span class="book-data"><%= selectedDate.DepartureDate.ToShortDateString()%></span>
                        <% } %>
                    </td>
                    <td>
                        <label for="if_date_retour"><%= Caval_go.Controllers.cmsController.getLangVersion("Date retour") %>:</label>
                        <% if ((!isProductSelected) || (Model.ProductFullInfoLang.Product.AllYearRound == true))
                           { %>
                        <input type="text" name="date_retour" id="if_date_retour" class="datepicker required" />
                        <% }
                           else
                           { %>
                        <%= Html.Hidden("date_retour", selectedDate.ReturnDate.ToShortDateString())%>
                        <span class="book-data"><%= selectedDate.ReturnDate.ToShortDateString()%></span>
                        <% } %>
                    </td>
                    <td>
                        <label for="if_dateFlexibility"><%= Caval_go.Controllers.cmsController.getLangVersion("A plus ou moins") %></label>
                        <input type="text" name="dateFlexibility" id="if_dateFlexibility" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="if_adultsCount"><%= Caval_go.Controllers.cmsController.getLangVersion("Nombre d'adultes") %></label>
                        <input type="text" name="adultsCount" id="if_adultsCount" class="required" />
                    </td>
                    <td>
                       <label for="if_childrenCount"><%= Caval_go.Controllers.cmsController.getLangVersion("Nombre d'enfants") %></label>
                        <input type="text" name="childrenCount" id="if_childrenCount" />
                    </td>
                    <td>
                        
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <label for="if_indvidualRooms"><input type="checkbox" name="indvidualRooms" id="if_indvidualRooms" style="width: auto;" />  <%= Caval_go.Controllers.cmsController.getLangVersion("Hébergement en chambre individuelle (supplément possible)") %></label>
                        
                        <br />
                        
                        <%= Caval_go.Controllers.cmsController.getLangVersion("Aérien inclus") %>:
                        <label><input type="radio" name="airIncluded" value="true" /> <%= Caval_go.Controllers.cmsController.getLangVersion("oui") %></label>
                        <label><input type="radio" name="airIncluded" value="false" /> <%= Caval_go.Controllers.cmsController.getLangVersion("non") %></label>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <br />
                        <label for="if_comments"><%= Caval_go.Controllers.cmsController.getLangVersion("Décrivez votre projet, vos envies, les voyages, extensions et activités qui vous intéressent") %>:</label>
                        <textarea name="comments" id="if_comments" class="full-width"></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"><h3><%= Caval_go.Controllers.cmsController.getLangVersion("Vos coordonnées") %></h3></td>
                </tr>
                <tr>
                  	<td><label for="if_Nom"><%= Caval_go.Controllers.cmsController.getLangVersion("Nom") %>*</label>
               	    <input name="Nom" id="if_Nom" class="required" /></td>
                  	<td><label for="if_Prenom"><%= Caval_go.Controllers.cmsController.getLangVersion("Prénom") %>*</label>
               	    <input name="Prenom" id="if_Prenom" class="required" /></td>
                  	<td width="48">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2"><label for="if_Address"><%= Caval_go.Controllers.cmsController.getLangVersion("Adresse") %>*</label>
                   	<input name="Adresse" id="if_Address" class="required full-width" /></td>
                  	<td>&nbsp;</td>
                </tr>
                <tr>
                    <td><label for="if_Codepostal"><%= Caval_go.Controllers.cmsController.getLangVersion("Code postal") %>*</label>
                   	<input name="Codepostal" id="if_Codepostal" class="required" /></td>
                   	<td><label for="if_Ville"><%= Caval_go.Controllers.cmsController.getLangVersion("Ville") %>*</label>
                   	<input name="Ville" id="if_Ville" class="required" /></td>
                   	<td><label for="if_Country"><%= Caval_go.Controllers.cmsController.getLangVersion("Pays") %>*</label>
                   	<input name="Country" id="if_Country" class="required" /></td>
                </tr>
                <tr>
                    <td><label for="if_Telephone"><%= Caval_go.Controllers.cmsController.getLangVersion("Téléphone") %>*</label>
                   	<input name="Telephone" id="if_Telephone" class="required" /></td>
                   	<td><label for="if_Email"><%= Caval_go.Controllers.cmsController.getLangVersion("Email") %>*</label>
                   	<input name="Email" id="if_Email" class="required email" /></td>
                  	<td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3">
                        <label><input type="checkbox" value="yes" name="Newsletter" style="width: auto;" /> <%= Caval_go.Controllers.cmsController.getLangVersion("Je souhaite recevoir la newsletter Caval&go") %></label>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <br />
                        <a href="javascript:;" onclick="$('#form_book_trip').submit();" class="bt-general white-bg"><span><%= Caval_go.Controllers.cmsController.getLangVersion("Réserver") %> »</span></a>
                    </td>
                </tr>
            </table>

        </fieldset>

        	<input name="action" type="hidden" value="sendmail" />
            <input name="subjectLine" type="hidden" value="Réservation en ligne" />
            <input name="redirectUrl" type="hidden" value="/cms/reservation-confirmation" />
            <input name="mailFrom" type="hidden" value="no-reply@cavalandgo.com" />
            <input name="mailTo" type="hidden" value="contact@cavalandgo.com" />

    </form>

    <%= Caval_go.Controllers.cmsController.getCmsBlockByName("Devis_Bas").Code%>

    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="LeftColumnContent" runat="server">
</asp:Content>

