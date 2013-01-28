<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Products_Info>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edition de Produit par Langue
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edition de Produit par Langue</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            
            <%= Html.HiddenFor(model => model.ProductInfoId) %>
            
            <div class="editor-label">
                <label for="Title">Nom de la destination</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("Title", Model.Title)%>
                <%= Html.ValidationMessageFor(model => model.Title)%>
            </div>
                        
            <div class="editor-label">
                <label for="MetaDescription">Meta Description</label>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.MetaDescription) %>
                <%= Html.ValidationMessageFor(model => model.MetaDescription)%>
            </div>
            
            <div class="editor-label">
                <label for="MetaKeywords">Meta Keywords</label>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.MetaKeywords) %>
                <%= Html.ValidationMessageFor(model => model.MetaKeywords)%>
            </div>
            
            <div class="editor-label">
                <label for="MetaTitle">Meta Title</label>
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.MetaTitle) %>
                <%= Html.ValidationMessageFor(model => model.MetaTitle)%>
            </div>
            
            <div class="editor-label">
                <label for="UrlCustomSegment">Custom URL Segment</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.UrlCustomSegment, new { @class = "full-width" })%>
                <%= Html.ValidationMessageFor(model => model.UrlCustomSegment)%>
            </div>

            <div class="editor-label">
                <label for="ShortDescription">Description Courte</label> (<a href="javascript:;" onclick="toggleGenericEditor('ShortDescription');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.ShortDescription) %>
                <%= Html.ValidationMessageFor(model => model.ShortDescription) %>
            </div>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.Description) %> (<a href="javascript:;" onclick="toggleGenericEditor('Description');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextAreaFor(model => model.Description)%>
                <%= Html.ValidationMessageFor(model => model.Description) %>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("< Retour", "product_infos", new { id = Model.ProductId })%>
    </div>

</asp:Content>

