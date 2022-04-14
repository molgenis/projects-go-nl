<template>
  <div class="go-nl-publications col-sm-10 col-md-8 col-lg-7 m-auto">
    <h1>Publications</h1>
    <p>In the list below, you can view all of the publications that are affiliated with the GoNL consortium. Publications are sorted by most recent publication. If you would like to add your publication to this list, make sure you have given suitable acknowledgement. Please see the <a href="https://nlgenome.nl/api/files/aaaac5z7aijfr6qwh32jd7yaae?alt=media">GoNL Publication Acknowledgment Guide (PDF, 139KB)</a> for more information.</p>
    <ol v-if="publications" class="publication-list" reversed>
      <PublicationRecord
        v-for="pub in publications"
        :key="pub.uid"
        :title="pub.title"
        :authors="pub.authors"
        :journalName="pub.fulljournalname"
        :publicationDate="pub.sortpubdate"
        :doiUrl="pub.doi_url"
        :doiLabel="pub.doi_label"
      />
    </ol>
  </div>
</template>

<script>
import PublicationRecord from './components/Publication.vue'

export default {
  data () {
    return {
      publications: []
    }
  },
  components: {
    PublicationRecord
  },
  methods: {
    async getPublicationData () {
      const response = await fetch('/api/v2/publications_records?sort=sortpubdate:desc')
      const data = await response.json()
      this.publications = data.items
    }
  },
  mounted () {
    this.getPublicationData()
  }
}
</script>
