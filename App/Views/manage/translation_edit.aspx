<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_LanguageTranslations>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	translation_edit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Traductions - Editer</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Editer une traduction</legend>
            <%= Html.HiddenFor(model => model.LanguageTranslationId) %>
            
            <div class="editor-label">
                <label for="Original">Original</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.Original, new { @class = "required" }) %>
                <%= Html.ValidationMessageFor(model => model.Original) %>
            </div>
            
            <div class="editor-label">
                <label for="Translated">Traduction</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.Translated, new { @class = "required" })%>
                <%= Html.ValidationMessageFor(model => model.Translated) %>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("Retour", "translations", "manage") %>
    </div>

</asp:Content>

