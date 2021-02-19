<script setup>
import Publication from "./components/Publication.vue";
</script>

<template>
  <h1>Publications</h1>
  <p>
    Here you can find a list of recent publications. If you would like to add
    you publication to this list, make sure it is available on
    <a
      href="http://www.ncbi.nlm.nih.gov/pubmed?term=Genome+of+the+Netherlands+Consortium[Corporate+Author]"
    >
      PubMed</a
    >
    and contact the GoNL consortium.
  </p>
  <ol class="publication-list" reversed>
    <Publication v-for="pub in pubs" :pub="pub" />
  </ol>
</template>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin: 0 auto;
  margin-top: 60px;
  max-width: 972px;
}
</style>

<script>
export default {
  data: function () {
    return {
      pubs: null,
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
          console.error("Failed to get Publications:", error);
        });
    },
  },
  mounted: function () {
    this.fetchData();
  },
};
</script>