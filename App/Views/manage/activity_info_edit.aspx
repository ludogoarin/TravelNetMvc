<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Activities_Info>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Edit - Activité par Langue
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editer - Activité par Langue</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.HiddenFor(model => model.ActivityInfoId)%>
            
            <div class="editor-label">
                <label for="activityName"><%= Model.Name %></label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("activityName", Model.Name)%>
                <%= Html.ValidationMessageFor(model => model.Name) %>
            </div>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.ShortDescription) %> (<a href="javascript:;" onclick="toggleGenericEditor('ShortDescription');">load/unload editor</a>)
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
        <%= Html.ActionLink("< Retour", "activity_infos", new { id = Model.ActivityId })%>
    </div>

</asp:Content>

