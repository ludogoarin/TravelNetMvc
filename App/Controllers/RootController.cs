using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Caval_go.Models;
using System.Configuration;

namespace Caval_go.Controllers
{
    public class RootController : Controller
    {
        caval_goEntities db = new caval_goEntities();

        // redirect to admin
        public void manage()
        {
            Response.Redirect("/manage/index");
        }

        public ActionResult destination(string keyname)
        {
            string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;

            var destinationInfo = (from d in db.cg_Destinations
                                   where d.Name.ToLower() == keyname.ToLower()
                                   from l in db.cg_Languages
                                   where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                                   from di in d.cg_Destinations_Info
                                   where di.LanguageId == l.LanguageId
                                   select di).FirstOrDefault();

            if (destinationInfo == null) destinationInfo = new cg_Destinations_Info();

            return View(destinationInfo);
        }

        //[OutputCache(Duration = 3600, VaryByParam = "")]
        public ActionResult index()
        {
            SearchEngine srcEngine = new SearchEngine();
            var homeModel = srcEngine.getSearchModel();

            return View(homeModel);
        }

        public ActionResult esprit()
        {
            var pg = cmsController.getCmsPageByName("esprit");
            return View("cms", pg);
        }

        [ActionName("groupes-pros")]
        public ActionResult groupes_pros()
        {
            var pg = cmsController.getCmsPageByName("groupes");
            return View("cms", pg);
        }

        [ActionName("nous-contacter")]
        public ActionResult nous_contacter()
        {
            var pg = cmsController.getCmsPageByName("contact");
            return View("cms", pg);
        }

        public ActionResult cms(string keyname)
        {
            var pg = cmsController.getCmsPageByName(keyname);

            return View(pg);
        }

    }
}
