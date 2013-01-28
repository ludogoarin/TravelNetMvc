<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_SitePhotos>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	site_photo_edit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editer une photo</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            <%= Html.Hidden("SitePhotoId", Model.SitePhotoId)%>
            <%= Html.Hidden("PhotoType", Model.PhotoType)%>
            <%= Html.Hidden("ParentId", Model.ParentId)%>

            <table>
                <td>
                    <img src="/img/view?path=/content/site-photos/<%= Model.SitePhotoId + Model.FileExtension %>&width=200&height=200" />
                </td>
                <td>
                    Filename: <%= Model.OriginalFileName %><br />
                </td>
            </table>
            
            <div class="editor-label">
                <label for="Description">Description</label> (<a href="javascript:;" onclick="toggleGenericEditor('Description');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Description", Model.Description, new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Description", "*")%>
            </div>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.Link) %>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.Link) %>
                <%= Html.ValidationMessageFor(model => model.Link) %>
            </div>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.AlternativeText)%>
            </div>
            <div class="editor-field">
                <%= Html.TextBoxFor(model => model.AlternativeText)%>
                <%= Html.ValidationMessageFor(model => model.AlternativeText)%>
            </div>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

