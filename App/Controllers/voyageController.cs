using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Caval_go.Models;
using System.Configuration;

namespace Caval_go.Controllers
{
    public class voyageController : Controller
    {
        caval_goEntities db = new caval_goEntities();
        ProductService prodSvc = new ProductService();

        //
        // GET: /voyage/

        public ActionResult Index()
        {
            return RedirectToAction("search");
        }

        #region Search

        //[OutputCache(Duration=3600, VaryByParam="destination;activityId")]
        public ActionResult destinations(string destination, string activityId)
        {
            Caval_go.Models.SearchEngine srcEngine = new Caval_go.Models.SearchEngine();
            activityId = activityId.ToLower();
            destination = destination.ToLower();
            string tag = Request.QueryString["tag"];
            long iActivityId = 0;
            if ((!String.IsNullOrEmpty(activityId)) && (activityId != "all")) {
                iActivityId = Convert.ToInt64(activityId);
            }
            var vwModel = prodSvc.searchProducts(tag, destination, iActivityId);
            vwModel.SearchEngineModel = srcEngine.getSearchModel();

            return View(vwModel);
        }

        //[OutputCache(Duration = 3600, VaryByParam = "destination;tag;activityId")]
        public ActionResult Search(string tag, string destination)
        {
            Caval_go.Models.SearchEngine srcEngine = new Caval_go.Models.SearchEngine();
            long activityId = 0;
            if (!String.IsNullOrEmpty(Request.QueryString["activityId"])) activityId = Convert.ToInt64(Request.QueryString["activityId"]);
            string profile = Request.QueryString["profile"];
            var vwModel = prodSvc.searchProducts(tag + (String.IsNullOrEmpty(profile) ? "" : "," + profile), destination, activityId);
            vwModel.SearchEngineModel = srcEngine.getSearchModel();
            return View(vwModel);
        }

        #endregion

        #region Product View

        //[OutputCache(Duration = 3600, VaryByParam = "id;keyword")]
        public ActionResult detail(long id, string keyword)
        {
            ProductFullInfoByLanguage pfi = prodSvc.getProductFullInfoByLanguage(id);
            return View(pfi);
        }

        #endregion

        #region Book

        public ActionResult book(long? id)
        {
            ProductBookingPageInfo bookPageInfo = new ProductBookingPageInfo();

            if ((id != null) && (id > 0))
            {
                long productId = (long)id;
                ProductFullInfoByLanguage pfi = prodSvc.getProductFullInfoByLanguage(productId);
                bookPageInfo.ProductFullInfoLang = pfi;


                // Departure dates
                List<SelectListItem> derpartureItems = new List<SelectListItem>();
                DateTime today = DateTime.Now;

                SelectListItem viewAllDepartures = new SelectListItem();
                viewAllDepartures.Text = "- Départ -";
                viewAllDepartures.Value = "all";
                derpartureItems.Add(viewAllDepartures);

                foreach (var dep in pfi.Dates)
                {
                    SelectListItem item = new SelectListItem();
                    item.Text = dep.DepartureDate.ToShortDateString();
                    item.Value = dep.DepartureDate.ToShortDateString();

                    derpartureItems.Add(item);
                }

                bookPageInfo.DepartureDates = derpartureItems;
            }

            return View(bookPageInfo);
        }

        #endregion

    }
}
