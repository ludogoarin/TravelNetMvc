<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_SitePhotos>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	site_photos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Photos</h2>
    <div class="on-list-new-form">
        <a href="javascript:;" onclick="$('.toggle-form.images').toggle();">Nouvelle photo »</a>
        <div class="toggle-form images">
        <% using (Html.BeginForm("site_photo_new", "manage", FormMethod.Post, new { enctype = "multipart/form-data" }))
            {
                %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouvelle photo</legend>
            <%= Html.Hidden("ParentId", ViewContext.RouteData.Values["parentId"])%>
            <%= Html.Hidden("PhotoType", ViewContext.RouteData.Values["photoType"])%>
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

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Editer", "site_photo_edit", new { id = item.SitePhotoId, parentId = item.ParentId, photoType = item.PhotoType })%> | 
                <%= Html.ActionLink("Supprimer", "site_photo_delete", new { id = item.SitePhotoId, parentId = item.ParentId, photoType = item.PhotoType }, new { @class = "delete_action" })%>
            </td>
            <td>
                <% using (Html.BeginForm("site_photo_neworder", "manage"))
                    { %>
                    <%= Html.TextBox("ListOrder", item.ListOrder, new { @class = "small" })%>
                    <%= Html.Hidden("SitePhotoId", item.SitePhotoId) %>
                    <%= Html.Hidden("ParentId", item.ParentId)%>
                    <%= Html.Hidden("PhotoType", item.PhotoType)%>
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
                <img src="/img/view?path=/content/site-photos/<%= item.SitePhotoId + item.FileExtension %>&width=100&height=60" style="max-width: 400px; max-height: 300px;" />
            </td>
        </tr>
    
    <% } %>

    </table>
</asp:Content>
