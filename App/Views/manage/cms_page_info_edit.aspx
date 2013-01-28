<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_cms_Pages_Info>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	cms_page_info_edit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        caval_goEntities db = new caval_goEntities();
            
        // make list of select items for RingId's
        List<SelectListItem> ddlLangItems = new List<SelectListItem>();
        List<cg_Languages> colLanguages = db.cg_Languages.OrderBy(l => l.Name).ToList();
        cg_Languages currentLanguage = db.cg_Languages.Where(l => l.LanguageId == Model.LanguageId).FirstOrDefault();

        foreach (cg_Languages language in colLanguages)
        {
            SelectListItem item = new SelectListItem();
            item.Selected = language.LanguageId == Model.LanguageId;
            item.Text = language.Name;
            item.Value = language.LanguageId.ToString();

            ddlLangItems.Add(item);
        }
    %>

    <h2>Gestion de Contenu par Langue (<%= currentLanguage.Name %>)</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.HiddenFor(model => model.CmsPageInfoId) %>
            
            <div class="editor-label">
                <label for="pageName">Nom de la page</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("pageName", Model.Name)%>
                <%= Html.ValidationMessageFor(model => model.Name) %>
            </div>
            
            <div class="editor-label">
                <label for="Tag_Title">Meta Title</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.Tag_Title) %>
                <%= Html.ValidationMessageFor(model => model.Tag_Title) %>
            </div>
            
            <div class="editor-label">
                <label for="Tag_Keywords">Meta Keywords</label>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.Tag_Keywords)%>
                <%= Html.ValidationMessageFor(model => model.Tag_Keywords) %>
            </div>
            
            <div class="editor-label">
                <label for="Tag_Description">Meta Description</label>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.Tag_Description)%>
                <%= Html.ValidationMessageFor(model => model.Tag_Description) %>
            </div>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.Code) %>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.Code, new { @class = "wysiwyg" })%>
                <%= Html.ValidationMessageFor(model => model.Code) %>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("< Retour", "cms_page_infos", new { id = Model.CmsPageId })%>
    </div>

</asp:Content>

