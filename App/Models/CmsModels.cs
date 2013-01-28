using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Caval_go.Models
{
    #region Models

    public class CmsPageInfoLanguage
    {
        public cg_cms_Pages CmsPage { get; set; }
        public cg_cms_Pages_Info CmsPageInfo { get; set; }
        public cg_Languages Language { get; set; }
    }

    public class CmsStaticBlockInfoLanguage
    {
        public cg_cms_StaticBlocks Block { get; set; }
        public cg_cms_StaticBlocks_Info BlockInfo { get; set; }
        public cg_Languages Language { get; set; }
    }

    #endregion

    #region Service

    public class CmsService
    {
    }

    #endregion
}