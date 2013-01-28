using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Caval_go.Models;
using Caval_go.Controllers;
using System.Configuration;
using System.Globalization;

namespace Caval_go.Models
{
    public class SearchModels
    {
    }

    public class SearchEngineModel
    {
        public List<SelectListItem> destinations { get; set; }
        public List<SelectListItem> profiles { get; set; }
        public List<SelectListItem> departues { get; set; }
        public List<SelectListItem> budgets { get; set; }
        public SlideshowModel slideshow { get; set; }
    }

    public class SlideshowModel
    {
        public cg_Slideshows Slideshow { get; set; }
        public IEnumerable<cg_SitePhotos> Slides { get; set; }
    }

    #region Services

    public class SearchEngine
    {
        caval_goEntities db = new caval_goEntities();
        HttpRequest Request = HttpContext.Current.Request;
        HttpResponse Response = HttpContext.Current.Response;

        public SearchEngineModel getSearchModel()
        {
            string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;
            var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];

            long defaultLanguageId = db.cg_Languages.Where(l => l.SystemLocale == defaultCulture).FirstOrDefault().LanguageId;

            // prepare filters
            string tagFilter = Request.QueryString["tag"];
            string profileFilter = Request.QueryString["profile"];
            string destFilter = Request.QueryString["destination"];
            string nameFilter = Request.QueryString["src_productName"];
            string codeFilter = Request.QueryString["src_productCode"];
            string departureFilter = Request.QueryString["dep"];

            var homeData = (from l in db.cg_Languages
                            where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                            select new
                            {
                                // destinations
                                destinations =
                                (from d in db.cg_Destinations
                                 from di in d.cg_Destinations_Info
                                 where di.LanguageId == (d.cg_Destinations_Info.Where(inf => inf.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
                                 select new { destName = di.Name, destLanguageName = di.Name, destUrlCustomSegment = di.UrlCustomSegment }).Distinct().OrderBy(d => d.destLanguageName),

                                // profiles
                                profiles =
                               (from pt in db.cg_Products_Tags
                                where pt.Type == "profile"
                                from pti in pt.cg_Products_Tags_Info
                                where pti.LanguageId == (pt.cg_Products_Tags_Info.Where(inf => inf.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
                                select new { tagName = pti.cg_Products_Tags.Tag, tagLanguageName = pti.Name, listOrder = pti.cg_Products_Tags.ListOrder }).Distinct().OrderBy(t => t.listOrder),

                            }).FirstOrDefault();

            List<SelectListItem> destItems = new List<SelectListItem>();
            SelectListItem viewAllDestinations = new SelectListItem();

            viewAllDestinations.Text = "- " + cmsController.getLangVersion("Destination") + " -";
            viewAllDestinations.Value = "all";
            viewAllDestinations.Selected = destFilter == "" ? true : false;
            destItems.Add(viewAllDestinations);

            foreach (var destination in homeData.destinations)
            {
                SelectListItem item = new SelectListItem();
                item.Text = destination.destLanguageName;
                item.Value = destination.destUrlCustomSegment.ToLower();
                item.Selected = destFilter == item.Value ? true : false;

                destItems.Add(item);
            }

            // make list of select items for tags
            SelectListItem viewAllTags = new SelectListItem();
            List<SelectListItem> profileTagItems = new List<SelectListItem>();
            viewAllTags.Text = "- " + cmsController.getLangVersion("Profil") + " -";
            viewAllTags.Value = "all";
            viewAllTags.Selected = tagFilter == "" ? true : false;
            profileTagItems.Add(viewAllTags);

            foreach (var tag in homeData.profiles)
            {
                SelectListItem item = new SelectListItem();
                item.Text = tag.tagLanguageName;
                item.Value = tag.tagName.ToLower();
                item.Selected = ((tagFilter == item.Value) || (profileFilter == item.Value)) ? true : false;

                profileTagItems.Add(item);
            }

            // Departure dates
            List<SelectListItem> derpartureItems = new List<SelectListItem>();
            DateTime today = DateTime.Now;

            SelectListItem viewAllDepartures = new SelectListItem();
            viewAllDepartures.Text = "- " + cmsController.getLangVersion("Départ") + " -";
            viewAllDepartures.Value = "all";
            viewAllDepartures.Selected = departureFilter == "" ? true : false;
            derpartureItems.Add(viewAllDepartures);

            for (int newMonth = 0; newMonth <= 12; newMonth++)
            {
                DateTime adjustedDate = today.AddMonths(newMonth);
                SelectListItem item = new SelectListItem();
                item.Text = adjustedDate.ToString("MMMM") + " " + adjustedDate.Year;
                item.Value = adjustedDate.ToShortDateString();
                item.Selected = departureFilter == item.Value ? true : false;

                derpartureItems.Add(item);
            }


            // Budget
            List<SelectListItem> budgetItems = new List<SelectListItem>();
            string langUpTo = cmsController.getLangVersion("jusqu'à");
            string budgetFilter = Request.QueryString["budget"];
            budgetItems.Add(new SelectListItem() { Text = "- " + cmsController.getLangVersion("Budget") + " -", Value = "all", Selected = budgetFilter == "all" });
            budgetItems.Add(new SelectListItem() { Text = langUpTo + " 4500", Value = "4500", Selected = budgetFilter == "4500" });
            budgetItems.Add(new SelectListItem() { Text = langUpTo + " 3500", Value = "3500", Selected = budgetFilter == "3500" });
            budgetItems.Add(new SelectListItem() { Text = langUpTo + " 2500", Value = "2500", Selected = budgetFilter == "2500" });
            budgetItems.Add(new SelectListItem() { Text = langUpTo + " 1500", Value = "1500", Selected = budgetFilter == "1500" });

            SearchEngineModel homeModel = new SearchEngineModel()
            {
                budgets = budgetItems,
                departues = derpartureItems,
                destinations = destItems,
                profiles = profileTagItems
            };

            // Slideshow
            var homeSlideshow = new SlideshowModel();

            homeSlideshow.Slideshow = db.cg_Slideshows.Where(s => s.SlideshowKey == "home-slideshow" && (s.LanguageCode == IetfLanguageTag)).FirstOrDefault();
            
            if (homeSlideshow.Slideshow == null) homeSlideshow.Slideshow = db.cg_Slideshows.Where(s => s.SlideshowKey == "home-slideshow" && (s.LanguageCode == defaultCulture)).FirstOrDefault();
            homeSlideshow.Slides = db.cg_SitePhotos.Where(p => p.ParentId == homeSlideshow.Slideshow.SlideshowId && p.PhotoType == "slideshow").OrderBy(p => p.ListOrder);
            homeModel.slideshow = homeSlideshow;

            return homeModel;
        }
    }
    #endregion
}