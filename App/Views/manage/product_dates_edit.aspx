<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.cg_Products_Dates>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	product_edit_date
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editer une date</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
            <legend>Date à éditer</legend>
            
            <%= Html.ValidationSummary(true) %>
            <%= Html.Hidden("ProductDateId", Model.ProductDateId)%>
            <%= Html.Hidden("ProductId", Request.QueryString["prodid"])%>

                <fieldset>
            
                    <div class="editor-label">
                        <label for="date_departure">Du</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("date_departure", Model.DepartureDate.ToShortDateString(), new { @class = "required date datepicker" })%>
                    </div>
            
                    <div class="editor-label">
                        <label for="date_return">Au</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("date_return", Model.ReturnDate.ToShortDateString(), new { @class = "required date datepicker" })%>
                    </div>
            
                    <div class="editor-label">
                        <label for="mini_pers">Minimum de personnes</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("mini_pers", Model.MiniPersons, new { @class = "required numberDE" })%>
                    </div>
            
                    <div class="editor-label">
                        <label for="date_price">Prix (TTC)</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("date_price", Model.Price, new { @class = "required numberDE" })%>
                    </div>
            
                    <div class="editor-label">
                        <label for="date_price">Prix Vol</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("flight_price", Model.FlightPrice, new { @class = "required numberDE" })%>
                    </div>
            
                    <p>
                        <input type="submit" value="Sauvegarder »" />  <%= Html.ActionLink("annuler", "product_edit", new { id = Request.QueryString["prodid"] })%>
                    </p>
                </fieldset>


    <% } %>

</asp:Content>

