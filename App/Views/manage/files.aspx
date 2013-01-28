<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.fileManageModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Files</h2>

    <h3>Current folder: <%= Model.currentRelativePath %></h3>
    <br />
    <div>
    Move to: <%= Html.DropDownList("filemanager_directory", Model.directorySelectList)%>
    </div>
    <br />
    <div class="on-list-new-form" style="float: left; width: 45%;">
        <a href="javascript:;" onclick="$('.toggle-form.file').toggle(); $('.toggle-form.directory').hide()">New file »</a>
        <a href="javascript:;" onclick="$('.toggle-form.directory').toggle();$('.toggle-form.file').hide()">New directory »</a>
        <a href="/manage/directory_delete/?deldir=<%= Model.currentRelativePath %>&dir=<%= Request.QueryString["dir"] %>" class="delete_action">Delete this directory »</a>

        <div class="toggle-form file">
        <% using (Html.BeginForm("files_new", "manage", FormMethod.Post, new { enctype = "multipart/form-data" }))
           {
               %>
            <%= Html.ValidationSummary(true) %>

            <%= Html.Hidden("dir", Request.QueryString["dir"]) %>

        <fieldset>
            <legend>New File</legend>
            
            <div class="editor-label">
                <label for="OriginalFileName">Select file</label>
            </div>
            <div class="editor-field">
                <input id="OriginalFileName" name="OriginalFileName" type="file" />
            </div>
            
            <p>
                <input type="submit" value="Upload File »" /> or <a href="javascript:;" onclick="$('.toggle-form.file').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>

        <div class="toggle-form directory">
        <% using (Html.BeginForm("directory_new", "manage", FormMethod.Post, new { enctype = "multipart/form-data" }))
           {
               %>
            <%= Html.ValidationSummary(true) %>

            <%= Html.Hidden("dir", Request.QueryString["dir"]) %>

        <fieldset>
            <legend>New Directory</legend>
            
            <div class="editor-label">
                <label for="OriginalFileName">New directory name</label>
            </div>
            <div class="editor-field">
                <input id="newDir" name="newDir" type="text" class="required" />
            </div>
            
            <p>
                <input type="submit" value="Create Folder »" /> or <a href="javascript:;" onclick="$('.toggle-form.directory').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>

    </div>


    <table class="full-width">
        <tr>
            <th></th>
            <th>
                File
            </th>
            <th>
                Size
            </th>
            <th>
                Last modified
            </th>
        </tr>

    <% foreach (var item in Model.files) { %>
    
        <tr>
            <td>
                <a href="<%= Model.currentRelativePath + item.Name %>" target="_blank">View</a> |
                <%= Html.ActionLink("Delete", "files_delete", new { file = Model.currentRelativePath + item.Name, dir = Request.QueryString["dir"] }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Name)%>
            </td>
            <td>
                <%= Html.Encode(Caval_go.Models.fileService.GetFileSize_Friendly(item))%>
            </td>
            <td>
                <%= Html.Encode(item.LastWriteTime.ToString())%>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

