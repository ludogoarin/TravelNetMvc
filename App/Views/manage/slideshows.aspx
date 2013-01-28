<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Slideshows>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	slideshows
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                    
        <%
            caval_goEntities db = new caval_goEntities();

            // make list of select items for RingId's
            List<SelectListItem> ddlLangItems = new List<SelectListItem>();
            List<cg_Languages> colLanguages = db.cg_Languages.OrderBy(l => l.Name).ToList();

            foreach (cg_Languages language in colLanguages)
            {
                SelectListItem item = new SelectListItem();
                item.Text = language.Name;
                item.Value = language.SystemLocale;

                ddlLangItems.Add(item);
            }
        %>

    <h2>Slideshows</h2>

    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Slideshow »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("slideshows_new", "manage", FormMethod.Post))
           {
        %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Slideshow</legend>
            
            <div class="editor-label">
                <label for="SlideshowName">Titre</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("SlideshowName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("SlideshowName", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="SlideshowKey">Slideshow Code Key</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("SlideshowKey", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("SlideshowKey", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="LanguageCode">Langue</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("LanguageCode", ddlLangItems)%>
                <%= Html.ValidationMessage("LanguageCode", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
    </div>

    <table class="full-width">
        <tr>
            <th></th>
            <th>
                SlideshowId
            </th>
            <th>
                SlideshowName
            </th>
            <th>
                SlideshowKey
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Editer", "slideshow_edit", new { id = item.SlideshowId })%> |
                <%= Html.ActionLink("Photos", "site_photos", new { parentId = item.SlideshowId, photoType = "slideshow" })%> |
                <%= Html.ActionLink("Supprimer", "slideshow_delete", new { id = item.SlideshowId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.SlideshowId) %>
            </td>
            <td>
                <%= Html.Encode(item.SlideshowName) %>
            </td>
            <td>
                <%= Html.Encode(item.SlideshowKey) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

