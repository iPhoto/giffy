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
        public ApiResult<List<GifContainer>> Get()
        {
            var userName = this.UserName.ToLower();
            var gifContainers =
                new GifContainerRepository().Models
                .Where(c => c.CreatedBy == userName)
                .ToList();

            return Success(gifContainers);
        }

        [HttpPost]
        public ApiResult<int> Start()
        {
            var builder = this.GifModule.StartBuild();
            return Success(builder.ID);
        }

        [HttpPost]
        public ApiResult<bool> Add(GifComponent component)
        {
            this.GifModule.AddToBuild(component);
            return Success(true);
        }

        [HttpPost]
        public ApiResult<GifContainer> Finish(int builderID)
        {
            var gifContainer = this.GifModule.FinishBuild(builderID);
            return Success(gifContainer);
        }

        [HttpPost]
        public ApiResult<bool> AddDescription(int id, string name, string description)
        {
            this.GifModule.AddDescription(id, name, description);
            return Success<bool>(true);
        }

        #endregion //Methods
    }
}
