<script setup>
import Publication from "./components/Publication.vue";
</script>

<template>
  <div id="publist-container">
    <h1 class="h1">Publications</h1>
    <p>
      In the list below, you can view all publications associated with GoNL
      consortium. If you would like to add you publication to this list, make
      sure you have given suitable acknowledgement (<a
        href="https://nlgenome.nl/api/files/aaaac5z7aijfr6qwh32jd7yaae?alt=media"
        >GoNL Publication Acknowledgment document (PDF, 139KB)</a
      >) and contact the GoNL consortium.
    </p>
    <ol v-if="pubs" class="publication-list" reversed>
      <Publication v-for="pub in pubs" v-bind:key="pub.uid" v-bind:pub="pub" />
    </ol>
    <p v-else><strong>Error:</strong> {{ error }}</p>
  </div>
</template>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin: 0 auto;
  padding-top: 60px;
  max-width: 972px;
  min-height: 100vh;
  font-size: 16pt;
}
</style>

<script>
export default {
  data: function () {
    return {
      pubs: null,
      error: null,
    };
  },
  methods: {
    fetchData: function () {
      fetch("https://go-nl-acc.gcc.rug.nl/api/v1/publications_records", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          // "x-molgenis-token": "",
        },
      })
        .then((response) => {
          if (response.ok) {
            return response.json();
          } else {
            throw response;
          }
        })
        .then((data) => {
          this.pubs = data.items.sort((x, y) => {
            return new Date(y.sortpubdate) - new Date(x.sortpubdate);
          });
        })
        .catch((error) => {
          let msg = `Unable to retrieve publications at this time (${error.status}`;
          if (error.statusText) {
            msg = `${msg} ${error.statusText})`;
          } else {
            msg = `${msg})`;
          }
          this.error = msg;
          console.log(error);
        });
    },
  },
  mounted: function () {
    this.fetchData();
  },
};
</script>