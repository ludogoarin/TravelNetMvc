<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.ProductFullInfo>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editer - Produit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                    
        <%
            caval_goEntities db = new caval_goEntities();
            
           // make list of select items for RingId's
           List<SelectListItem> ddlTagItems = new List<SelectListItem>();
           List<cg_Products_Tags> colTags = db.cg_Products_Tags.OrderBy(t => t.Tag).ToList();

           var ctags = (from tg in db.cg_Products_Tags
                       select new { Tag = tg.Tag, TagId = tg.ProductTagId, IsSelected = db.cg_Products_Tags_Map.Where(tm => tm.cg_Products_Tags.ProductTagId == tg.ProductTagId && tm.cg_Products.ProductId == Model.Product.ProductId).Count() > 0 }).OrderBy(a => a.Tag);
            
           var cactivities = (from ac in db.cg_Activities
                             select new { ActivityName = ac.Name, ActivityId = ac.ActivityId, IsSelected = db.cg_Products_Activities_Map.Where(am => am.cg_Activities.ActivityId == ac.ActivityId && am.cg_Products.ProductId == Model.Product.ProductId).Count() > 0 }).OrderBy(a => a.ActivityName);

           // make list of select items for destinations
           List<SelectListItem> destItems = new List<SelectListItem>();
           List<cg_Destinations> colDestinations = db.cg_Destinations.OrderBy(d => d.Name).ToList();

           foreach (cg_Destinations destination in colDestinations)
           {
               SelectListItem item = new SelectListItem();
               item.Text = destination.Name;
               item.Value = destination.DestinationId.ToString();
               item.Selected = destination.DestinationId == Model.Destination.DestinationId;

               destItems.Add(item);
           }

            // make list of select items for activities
           List<SelectListItem> activityItems = new List<SelectListItem>();
           List<cg_Activities> colActivities = db.cg_Activities.OrderBy(a => a.Name).ToList();

           foreach (cg_Activities activity in colActivities)
           {
               SelectListItem item = new SelectListItem();
               item.Text = activity.Name;
               item.Value = activity.ActivityId.ToString();

               if (Model.Activity != null)
               {
                   if (Model.Activity.ActivityId == activity.ActivityId) item.Selected = true;
               }
               activityItems.Add(item);
           }
        %>

    <h2>Editer - Produit</h2>

    <div>
        <%= Html.ActionLink("< Retour", "products") %>
    </div>
    <br />

    <table class="full-width">
        <tr>
            <td width="50%" valign="top">

                <h3>Nom, Code et Prix</h3>
                <% using (Html.BeginForm()) {%>
                    <%= Html.ValidationSummary(true) %>
                                                                                                                                                                                                                                                                                                                                                                                            <fieldset class="fields">
                    <%= Html.Hidden("ProductId", Model.Product.ProductId)%>

                    <div class="top-right-button">
                        <input type="submit" value="Sauvegarder" />
                    </div>
            
                    <div class="editor-label">
                        <label for="productName">Nom du produit</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBoxFor(model => model.Product.Name, new { @class = "required" })%>
                        <%= Html.ValidationMessageFor(model => model.Product.Name)%>
                    </div>
            
                    <div class="editor-label">
                        <label for="ProductCode">Code Produit</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBoxFor(model => model.Product.ProductCode)%>
                        <%= Html.ValidationMessageFor(model => model.Product.ProductCode)%>
                    </div>
            
                    <div class="editor-label">
                        <label for="Price">Prix (à partir de)</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBoxFor(model => model.Product.Price, new { @class = "small required" })%>
                        <%= Html.ValidationMessageFor(model => model.Product.Price)%>
                    </div>
            
                    <div class="editor-label">
                        <label for="Duration">Nombre de jours</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBoxFor(model => model.Product.Duration, new { @class = "small required" })%>
                        <%= Html.ValidationMessageFor(model => model.Product.Duration)%>
                    </div>
            
                    <div class="editor-label">
                        <label for="DestinationId">Destination</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.DropDownList("DestinationId", destItems)%>
                    </div>
            
                    <div class="editor-label">
                        <label for="Price">Assuré toute l'année</label> <%= Html.CheckBox("Product.AllYearRound", Convert.ToBoolean(Model.Product.AllYearRound)) %>
                    </div>

                <% } %>

            </td>
            <td width="50%" valign="top">

                <h3>Départs et tarifs</h3>
                <br />

                <div class="on-list-new-form">
                    <a href="javascript:;" onclick="$('.toggle-form.dates').toggle();">Nouvelle Date »</a>
                    <div class="toggle-form dates">
                    <% using (Html.BeginForm("product_dates_add", "manage", FormMethod.Post))
                       {
                           %>
                        <%= Html.ValidationSummary(true) %>
                        <%= Html.Hidden("ProductId", Model.Product.ProductId)%>

                    <fieldset>
            
                        <div class="editor-label">
                            <label for="date_departure">Du</label>
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBox("date_departure", "", new { @class = "required date datepicker" })%>
                            <%= Html.ValidationMessage("date_departure", "*")%>
                        </div>
            
                        <div class="editor-label">
                            <label for="date_return">Au</label>
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBox("date_return", "", new { @class = "required date datepicker" })%>
                            <%= Html.ValidationMessage("date_return", "*")%>
                        </div>
            
                        <div class="editor-label">
                            <label for="mini_pers">Minimum de personnes</label>
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBox("mini_pers", "", new { @class = "required numberDE" })%>
                            <%= Html.ValidationMessage("mini_pers", "*")%>
                        </div>
            
                        <div class="editor-label">
                            <label for="date_price">Prix (TTC)</label>
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBox("date_price", "", new { @class = "required numberDE" })%>
                            <%= Html.ValidationMessage("date_price", "*")%>
                        </div>
            
                        <div class="editor-label">
                            <label for="date_price">Prix Vol</label>
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBox("flight_price", "", new { @class = "required numberDE" })%>
                            <%= Html.ValidationMessage("flight_price", "*")%>
                        </div>
            
                        <p>
                            <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form.dates').hide()">cancel</a>
                        </p>
                    </fieldset>

                    <% } %>
                    </div>
                </div>

                <table class="full-width list">
                    <tr>
                        <th></th>
                        <th>
                            Du
                        </th>
                        <th>
                            Au
                        </th>
                        <th>
                            Prix
                        </th>
                        <th>
                            Prix vol
                        </th>
                        <th>
                            Mini pers.
                        </th>
                    </tr>

                <% foreach (var item in Model.Dates) { %>
    
                    <tr>
                        <td>
                            <%= Html.ActionLink("Editer", "product_dates_edit", new { id = item.ProductDateId, prodid = Model.Product.ProductId })%> | 
                            <%= Html.ActionLink("Supprimer", "product_dates_delete", new { id = item.ProductDateId, prodid = Model.Product.ProductId }, new { @class = "delete_action" })%>
                        </td>
                        <td>
                            <%= Html.Encode(item.DepartureDate.ToShortDateString())%>
                       </td>
                        <td>
                            <%= Html.Encode(item.ReturnDate.ToShortDateString()) %>
                       </td>
                        <td>
                            <%= String.Format("{0:C}", item.Price) %>
                       </td>
                        <td>
                            <%= String.Format("{0:C}", item.FlightPrice)%>
                       </td>
                        <td>
                            <%= Html.Encode(item.MiniPersons) %>
                       </td>
                    </tr>
    
                <% } %>

                </table>
            </td>
        </tr>
        <tr>
            <td width="50%" valign="top">

                <h3>Photos</h3>
                <br />
                <div class="on-list-new-form">
                    <a href="javascript:;" onclick="$('.toggle-form.images').toggle();">Nouvelle photo »</a>
                    <div class="toggle-form images">
                    <% using (Html.BeginForm("product_photo_new", "manage", FormMethod.Post, new { enctype = "multipart/form-data" }))
                       {
                           %>
                        <%= Html.ValidationSummary(true) %>

                    <fieldset>
                        <legend>Nouvelle photo</legend>
                        <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
            <%--            
                        <div class="editor-label">
                            <label for="Descrption">Descrption</label>
                        </div>
                        <div class="editor-field">
                            <%= Html.TextBox("Descrption")%>
                            <%= Html.ValidationMessage("Descrption", "*")%>
                        </div>
            --%>             
                       <div class="editor-label">
                            <label for="OriginalFileName">Selection du fichier</label>
                        </div>
                        <div class="editor-field">
                            <input id="OriginalFileName" name="OriginalFileName" type="file" />
                        </div>
            
                        <p>
                            <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form.images').hide()">cancel</a>
                        </p>
                    </fieldset>

                    <% } %>
                    </div>
                </div>

                <table class="full-width">
                    <tr>
                        <th></th>
                        <th>
                        Ordre
                        </th>
                        <th>
                        Image
                        </th style="width: 400px;">
                    </tr>

                <% foreach (var item in Model.Photos) { %>
    
                    <tr>
                        <td>
                            <%= Html.ActionLink("Supprimer", "product_photo_delete", new { id = item.ProductPhotoId, prodid = Model.Product.ProductId }, new { @class = "delete_action" })%>
                        </td>
                        <td>
                            <% using (Html.BeginForm("product_photo_neworder", "manage"))
                               { %>
                                <%= Html.TextBox("ListOrder", item.ListOrder, new { @class = "small" })%>
                                <%= Html.Hidden("ProductPhotoId", item.ProductPhotoId) %>
                                <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
                                <input type="submit" value="save" />
                            <% } %>
                        </td>
            <%--            <td>
                            <% using (Html.BeginForm("p_gallery_item_newcaption", "manage"))
                               { %>
                                <%= Html.TextBox("ProductPhotoId", item.Description, new { width = "200px"}) %>
                                <%= Html.Hidden("ProductPhotoId", item.ProductPhotoId) %>
                                <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
                                <input type="submit" value="save" />
                            <% } %>
                        </td>
            --%>            <td style="text-align: right; width: 200px;">
                            <img src="/img/view?path=/content/trip-photos/<%= item.ProductPhotoId + item.FileExtension %>&width=100&height=60" style="max-width: 400px; max-height: 300px;" />
                        </td>
                    </tr>
    
                <% } %>

                </table>

            </td>
            <td width="50%" valign="top">

                <h3>Activités</h3>
                <br />

                <% using (Html.BeginForm("product_activities_update", "manage"))
                    { %>
                    <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
                    <% foreach (var activity in cactivities)
                       { %>
                        <label>
                            <%= Html.CheckBox("productActivity", activity.IsSelected, new { value = activity.ActivityId })%>
                            <%= activity.ActivityName%>
                        </label>
                        <br />
                    <% } %>
                    <br />
                    <p>
                    <input type="submit" value="Sauvegrader »" />
                    </p>
                <% } %>
                <h3>Tags</h3>
                <br />

                <% using (Html.BeginForm("product_tags_update", "manage"))
                    { %>
                    <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
                    <% foreach (var tag in ctags)
                       { %>
                        <label>
                            <%= Html.CheckBox("productTag", tag.IsSelected, new { value = tag.TagId }) %>
                            <%= tag.Tag %>
                        </label>
                        <br />
                    <% } %>
                    <br />
                    <p>
                    <input type="submit" value="Sauvegrader »" />
                    </p>
                <% } %>

            </td>
        </tr>
    </table>

</asp:Content>

