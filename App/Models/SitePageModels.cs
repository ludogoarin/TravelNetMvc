using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Caval_go.Models
{
    #region Models

    public class Homepage
    {
        public cg_cms_Pages_Info CmsPageInfo { get; set; }
        public cg_Languages Language { get; set; }
        public List<cg_cms_StaticBlocks_Info> BlockInfo { get; set; }
        public List<cg_Destinations_Info> Destinations { get; set; }
    }

    #endregion
}