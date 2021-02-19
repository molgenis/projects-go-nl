# GoNL Custom Molgenis Apps

In this subdirectory, you can find all of the custom molgenis apps used in the new GoNL database. The following table provide information about each table and their current status.

| Name          | Status   | Description                                                 |
|---------------|----------|-------------------------------------------------------------|
| about         | live     | project information - mission, members, etc.                |
| browse        | live     | UI for searching data                                       |
| download_data | live     | information on downloading GoNL data                        |
| home\*        | live     | main home page                                              |
| news          | live     | announcements, events, etc.                                 |
| publist       | live     | Vue template for dynamically updating publications          |
| request       | live     | information about the data request process, links to podium |
| publications  | archived | list of publications                                        |

\***Note**: The `home` app doesn't follow the same structure as the other apps. The html file (`home/index.html`) is read by `emx_create_04_static_content.R` and saved as `data/sys_StaticContent.tsv`.

## Getting Started

There are a number of ways to create your own apps, you can can create them locally or use an online prototyping platform. For this project, I used [codepen.io](https://codepend.io) to create prototypes. [jsfiddle.net](https://jsfiddle.net) is a nice alternative.

### Rapid Prototyping using Codepen

To make the process of redesigning the pages easier, I created a [codepen.io](https://codepen.io/collection/XWWoVB) collection where I could create a prototype of each page using a standard codepen template. The codepen template comes with bootstrap4 and jquery already loaded. This approach is much easier for building new custom molgenis apps.

You can add to the codepen collection or you can easily create your own pen. To do so, follow these steps.

1. Go to [codepen.io](https://codepend.io) and create an account
2. Create a new pen and open it.
3. Next, add bootstrap and jquery to your pen. Open settings. You will have to manually link bootstrap and jquery, but this only needs to be done once.
    - Click the `CSS` menu tab: scroll down to `Add External Stylesheets/Pens`. In the search box, type and select `twitter-bootstrap`.
    - Click the `JS` menu tab: type and select `twitter-bootstrat`; type and select `jQuery`.
4. All of the apps use a standard html structure. Copy the following html into the HTML pane.

```html
<div id="" class="col-sm-7 offset-sm-3">
    ...
</div>
```

You are now ready to start designing your page!

## Background

The purpose of this section is to document the decisions and changes to the database.

### Shutting down the wordpress site

Due to a number of issues with custom urls and redirects (between the Molgenis server and the wordpress site), we decided to shut down the wordpress site and move the content into the Molgenis server. This approach would allow us to have all content (project info, background, etc) and data in a single place, as well as supplementary data (i.e., publications) and other information.

See `src/curl.sh` for code used to pull html pages from the wordpress site. The exported html files are located in `src/wordpress/`. All images were downloaded manually and saved in `src/images/`. All documents that were hosted on the wordpress site were also downloaded. These are stored in `src/docs/`

### Custom Molgenis App for Publications

There are two publications apps - `publications` and `publist`. `publications` is the first iteration of the publications app. This was abandoned as it required manual updates and I wanted something automated (I kept the old version just in case). The `publist` is the app used in production. This is Vue application that fetches data from the entity `publications_records` and dynamically renders the HTML. This is tied to the Github Action listed in `.github/workflows/`.

### Custom Molgenis App for News

In the wordpress site, each entry was a separate page. It wasn't necessary to keep this structure in the molgenis site as most entries contained 1-2 sentences. Instead, I restructured this page so that all entries were in one page.

### Data Request Form

This was one of the biggest challenges of the project. I tried to rewrite this as a Molgenis questionnaire, but I ran into permissions issues when moving it into production. I also restructured this page using the `data-row-edit` plugin. It worked, but I couldn't figure out the permissions for anonymous users. Instead, we decided to move this to Podium.
