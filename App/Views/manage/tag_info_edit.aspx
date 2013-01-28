<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Products_Tags_Info>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editer - Info Tag par langue
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editer - Info Tag par langue</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.HiddenFor(model => model.ProductTagId)%>
            <%= Html.HiddenFor(model => model.ProductTagInfoId)%>
             
            <div class="editor-label">
                <label for="tagName">Nom du tag</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("tagName", Model.Name)%>
                <%= Html.ValidationMessageFor(model => model.Name) %>
            </div>
           
            <div class="editor-label">
                <%= Html.LabelFor(model => model.Description) %>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.Description, new { @class = "wysiwyg" })%>
                <%= Html.ValidationMessageFor(model => model.Description)%>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("< Retour", "tag_infos", new { id = Model.ProductTagId })%>
    </div>

</asp:Content>

