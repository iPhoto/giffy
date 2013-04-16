using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Giffy.Models;
using Giffy.Models.Gifs;
using Giffy.Modules;
using Giffy.Repositories;

namespace Giffy.Controllers.Api.Gif
{
    public class GifController : AuthorizedApiController
    {
        #region Fields

        private GifModule gifModule;

        #endregion //Fields

        #region Properties

        protected GifModule GifModule
        {
            get 
            {
                if (this.gifModule == null)
                    this.gifModule = new GifModule();

                return this.gifModule;
            }
        }

        #endregion //Properties

        #region Methods

        [HttpGet]
        [ActionName("Default")]
        public ApiResult<GifContainer> Get(int id)
        { 
            var userName = this.UserName.ToLower();
            var gifContainer = 
                new GifContainerRepository().Models
                .Where(c => c.CreatedBy == userName)
                .FirstOrDefault();

            if (gifContainer == null)
                return Failure<GifContainer>("The specified GifContainer could not be found.");

            return Success(gifContainer);
        }

        [HttpGet]
        [ActionName("Default")]
        public ApiResult<IEnumerable<object>> Get(int? skip = null, int? take = null)
        {
            var userName = this.UserName.ToLower();
            var gifContainers =
                 from container in new GifContainerRepository().Models
                 where container.CreatedBy == userName
                 orderby container.CreatedOn descending
                 select new 
                 { 
                    container.ID,
                    container.Name,
                    container.Description,
                    container.Thumbnail
                 };

            if (skip.HasValue)
                gifContainers = gifContainers.Skip(skip.Value);
            if (take.HasValue)
                gifContainers = gifContainers.Take(take.Value);

            return Success(gifContainers.ToList() as IEnumerable<object>);
        }

        [HttpPost]
        public ApiResult<GifBuilder> Start()
        {
            var builder = this.GifModule.StartBuild();
            return Success(builder);
        }

        [HttpPost]
        public ApiResult<bool> Add(GifComponentTransport component)
        {
            this.GifModule.AddToBuild(component.ToGifComponent());
            return Success(true);
        }

        [HttpPost]
        public ApiResult<GifContainer> Finish(int builderID)
        {
            var gifContainer = this.GifModule.FinishBuild(builderID);
            return Success(gifContainer);
        }

        [HttpPost]
        public ApiResult<bool> AddDescription(GifContainerDescription description)
        {
            this.GifModule.AddDescription(
                description.GifContainerID, 
                description.Name, 
                description.Description);

            return Success<bool>(true);
        }

        #endregion //Methods
    }
}
