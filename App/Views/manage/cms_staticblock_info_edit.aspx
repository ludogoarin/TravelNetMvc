<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_cms_StaticBlocks_Info>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editer - Blocks de Contenu par langue
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editer - Blocks de Contenu par langue</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.HiddenFor(model => model.StaticBlockInfoId)%>
            
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
        <%= Html.ActionLink("< Retour", "cms_staticblock_infos", new { id = Model.StaticBlockId })%>
    </div>

</asp:Content>

