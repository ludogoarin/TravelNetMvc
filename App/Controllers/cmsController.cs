using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Caval_go.Models;
using System.Configuration;

namespace Caval_go.Controllers
{
    public class cmsController : Controller
    {
        //
        // GET: /cms/

        public ActionResult Index(string keyname)
        {
            var lang = Request.QueryString["lgview"];

            var pg = cmsController.getCmsPageByName(keyname, lang);

            if (lang != null)
            {
                try
                {
                    System.Threading.Thread.CurrentThread.CurrentCulture =
                               new System.Globalization.CultureInfo(lang);
                }
                catch
                {
                }
            }

            return View(pg);
        }

        public static cg_cms_Pages_Info getCmsPageByName(string pageName)
        {
            return getCmsPageByName(pageName, null);
        }

        public static cg_cms_Pages_Info getCmsPageByName(string pageName, string IetfLanguageTag)
        {
            caval_goEntities db = new caval_goEntities();

            if (IetfLanguageTag == null) IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;

            var pageInfo = (from ppg in db.cg_cms_Pages
                            where ppg.Name.ToLower() == pageName.ToLower()
                            from l in db.cg_Languages
                            where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                            from pi in ppg.cg_cms_Pages_Info
                            where pi.LanguageId == l.LanguageId
                            select pi).FirstOrDefault();

            if (pageInfo == null)
            {
                var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
                System.Globalization.CultureInfo cultureInfo = new System.Globalization.CultureInfo(defaultCulture);

                pageInfo = (from ppg in db.cg_cms_Pages
                            where ppg.Name.ToLower() == pageName.ToLower()
                            from l in db.cg_Languages
                            where l.SystemLocale.ToLower() == cultureInfo.IetfLanguageTag.ToLower()
                            from pi in ppg.cg_cms_Pages_Info
                            where pi.LanguageId == l.LanguageId
                            select pi).FirstOrDefault();
            }

            if (pageInfo == null) pageInfo = new cg_cms_Pages_Info();

            return pageInfo;
        }

        public static cg_cms_StaticBlocks_Info getCmsBlockByName(string blockName)
        {
            return getCmsBlockByName(blockName, null);
        }

        public static cg_cms_StaticBlocks_Info getCmsBlockByName(string blockName, string IetfLanguageTag)
        {
            caval_goEntities db = new caval_goEntities();

            if (IetfLanguageTag == null) IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;

            var blockInfo = (from pb in db.cg_cms_StaticBlocks
                             where pb.Name.ToLower() == blockName.ToLower()
                             from l in db.cg_Languages
                             where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                             from pi in pb.cg_cms_StaticBlocks_Info
                             where pi.LanguageId == l.LanguageId
                             select pi).FirstOrDefault();

            if (blockInfo == null)
            {
                var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
                System.Globalization.CultureInfo cultureInfo = new System.Globalization.CultureInfo(defaultCulture);
                blockInfo = (from pb in db.cg_cms_StaticBlocks
                             where pb.Name.ToLower() == blockName.ToLower()
                             from l in db.cg_Languages
                             where l.SystemLocale.ToLower() == cultureInfo.IetfLanguageTag.ToLower()
                             from pi in pb.cg_cms_StaticBlocks_Info
                             where pi.LanguageId == l.LanguageId
                             select pi).FirstOrDefault();
            }

            if (blockInfo == null) blockInfo = new cg_cms_StaticBlocks_Info();

            return blockInfo;
        }

        public static string getLangVersion(string input)
        {
            return getLangVersion(input, null);
        }

        public static string getLangVersion(string input, string IetfLanguageTag)
        {
            caval_goEntities db = new caval_goEntities();
            string output = input;

            if (IetfLanguageTag == null) IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;

            var langTranslate = (from l in db.cg_Languages
                                 where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                                 from lt in l.cg_LanguageTranslations
                                 where lt.Original == input
                                 select lt).FirstOrDefault();

            if (langTranslate == null)
            {
                var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
                System.Globalization.CultureInfo cultureInfo = new System.Globalization.CultureInfo(defaultCulture);

                langTranslate = (from l in db.cg_Languages
                                 where l.SystemLocale.ToLower() == cultureInfo.IetfLanguageTag.ToLower()
                                 from lt in l.cg_LanguageTranslations
                                 where lt.Original == input
                                 select lt).FirstOrDefault();
            }

            if (langTranslate != null)
            {
                output = langTranslate.Translated;
            }

            return output;
        }

    }
}
