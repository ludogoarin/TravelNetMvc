<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.CmsPageInfoLanguage>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	cms_page_infos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                    
    <%
        caval_goEntities db = new caval_goEntities();
            
        // make list of select items for RingId's
        List<SelectListItem> ddlLangItems = new List<SelectListItem>();
        List<cg_Languages> colLanguages = db.cg_Languages.OrderBy(l => l.Name).ToList();

        foreach (cg_Languages language in colLanguages)
        {
            if (Model.Where(di => di.Language.LanguageId == language.LanguageId).Count() == 0)
            {
                SelectListItem item = new SelectListItem();
                item.Text = language.Name;
                item.Value = language.LanguageId.ToString();

                ddlLangItems.Add(item);
            }
        }
    %>

    <h2>Detail de Page par Langue</h2>
    
    <div class="on-list-new-form">
        <a href="/manage/cms_pages">< Retour</a>

        <% if (ddlLangItems.Count() > 0) { %>
         | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Descriptif »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("cms_page_info_add", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Descriptif</legend>

            <%= Html.Hidden("PageId", ViewContext.RouteData.Values["id"])%>
            
            <div class="editor-label">
                <label for="pageName">Nom de la Page</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("pageName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("pageName", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="LanguageId">Langue</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("LanguageId", ddlLangItems)%>
                <%= Html.ValidationMessage("LanguageId", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Code">Code HTML</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Code", new { @class = "wysiwyg" })%>
                <%= Html.ValidationMessage("Code", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Tag_Title">Meta Title</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("Tag_Title")%>
                <%= Html.ValidationMessage("Tag_Title", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Tag_Description">Meta Description</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Tag_Description", new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Tag_Description", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Tag_Keywords">Meta Keywords</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Tag_Keywords", new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Tag_Keywords", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
        <% } %>
    </div>

    <table class="full-width">
        <tr>
            <th></th>
            <th>
                Langue
            </th>
            <th>
                Nom
            </th>
            <th>
                Preview
            </th>
        </tr>

    <% foreach (var item in Model) {

           var cmsItem = item.CmsPageInfo;
           %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "cms_page_info_edit", new { id = cmsItem.CmsPageInfoId })%> |
                <%= Html.ActionLink("Supprimer", "cms_page_info_delete", new { id = cmsItem.CmsPageInfoId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Language.Name) %>
            </td>
            <td>
                <%= Html.Encode(cmsItem.Name)%>
            </td>
            <td>
                <a href="/cms/<%= item.CmsPage.Name %>?lgview=<%= item.Language.SystemLocale %>" target="_blank">Preview</a>
            </td>
        </tr>
    
    <% } %>

    </table>
    <br />
    <div>
        <%= Html.ActionLink("< Retour", "cms_pages")%>
    </div>


</asp:Content>

