<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Slideshows>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	slideshow_edit
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
                item.Selected = language.SystemLocale == Model.LanguageCode;

                ddlLangItems.Add(item);
            }
        %>

    <h2>Editer un slideshow</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.HiddenFor(model => model.SlideshowId) %>
            
            <div class="editor-label">
                <label for="SlideshowName">Titre</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.SlideshowName) %>
                <%= Html.ValidationMessageFor(model => model.SlideshowName) %>
            </div>
            
            <div class="editor-label">
                <label for="SlideshowKey">Slideshow Code Key</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.SlideshowKey) %>
                <%= Html.ValidationMessageFor(model => model.SlideshowKey) %>
            </div>
            
            <div class="editor-label">
                <label for="LanguageCode">Langue</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("LanguageCode", ddlLangItems)%>
                <%= Html.ValidationMessage("LanguageCode", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("< retour", "slideshows")%>
    </div>

</asp:Content>

