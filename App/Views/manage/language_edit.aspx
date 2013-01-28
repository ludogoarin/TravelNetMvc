<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Languages>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editer - Langues
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editer - Langues</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.HiddenFor(model => model.LanguageId) %>
            
            <div class="editor-label">
                <label for="LanguageName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("LanguageName", Model.Name) %>
                <%= Html.ValidationMessageFor(model => model.Name) %>
            </div>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.SystemLocale) %>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.SystemLocale) %>
                <%= Html.ValidationMessageFor(model => model.SystemLocale) %>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("< Retour", "languages")%>
    </div>

</asp:Content>

