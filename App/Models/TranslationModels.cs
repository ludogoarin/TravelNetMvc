using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Caval_go.Models
{
    #region Models

    public class TranslationsFullView
    {
        public List<cg_LanguageTranslations> LanguageTranslations { get; set; }
        public List<cg_Languages> Language_ObjectList { get; set; }
        public List<SelectListItem> Languages_SelectList { get; set; }
    }

    #endregion


    #region Services

    public class TranslationService
    {
        caval_goEntities db = new caval_goEntities();

        public TranslationsFullView getTransations(long languageId)
        {
            var translations = new List<cg_LanguageTranslations>();

            if (languageId > 0)
            {
                translations = (from lg in db.cg_Languages
                                where lg.LanguageId == languageId
                                from lt in lg.cg_LanguageTranslations
                                select lt).OrderBy(t => t.Original).ToList();
            }
            else
            {
                translations = db.cg_LanguageTranslations.OrderBy(t => t.Original).ToList();
            }

            var view = new TranslationsFullView
                               {
                                   LanguageTranslations = translations.ToList(),
                                   Language_ObjectList = db.cg_Languages.ToList()
                               };

            // add a title inside the dropdown
            view.Languages_SelectList = new List<SelectListItem>();
            SelectListItem itemTitle = new SelectListItem { Text = "- all -", Value = "0" };
            view.Languages_SelectList.Add(itemTitle);

            foreach (var lang in view.Language_ObjectList)
            {
                SelectListItem item = new SelectListItem();
                item.Text = lang.Name;
                item.Value = lang.LanguageId.ToString();
                item.Selected = lang.LanguageId == languageId ? true : false;

                view.Languages_SelectList.Add(item);
            }
            
            return view;
        }
    }
    #endregion
}