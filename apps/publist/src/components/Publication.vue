<template>
  <li class="publication-record">
    <p class="record-data record-title">{{ title }}</p>
    <p class="record-data record-authors">{{ authors }}</p>
    <div class="record-metadata">
      <p class="record-data record-journal">{{ journalName }}</p>
      <p class="record-data record-year">{{ publicationYear }}</p>
      <a class="record-data record-doi" :href="doiUrl">
        {{ doiLabel ? doiLabel : doiUrl }}
      </a>
    </div>
  </li>
</template>

<script>
export default {
  name: 'PublicationRecord',
  props: {
    title: {
      type: String,
      required: true
    },
    authors: {
      type: String,
      required: true
    },
    journalName: {
      type: String,
      required: false
    },
    publicationDate: {
      type: String,
      required: false
    },
    doiUrl: {
      type: String,
      required: false
    },
    doiLabel: {
      type: String,
      required: false
    }
  },
  computed: {
    publicationYear () {
      return this.publicationDate.split('-')[0]
    }
  }
}
</script>

<style lang="scss">
.publication-record {
  margin-bottom: 1.65em;
  color: #3f454b;

  .record-data {
    margin: 0;
    font-weight: 400;
  }

  .record-title {
    display: block;
    color: #252525;
    line-height: 1.4;
    margin-bottom: 8px;
  }
  
  .record-authors {
    font-size: 11pt;
  }

  .record-metadata {
    display: flex;
    flex-wrap: wrap;
    flex-direction: row;

    .record-data {
      margin-top: 4px;
      font-size: 9pt;
      text-transform: uppercase;
      color: #5d666f;
    }

    p.record-data {
      &::after {
        content: '\2022';
        margin: 0 6px;
      }
    }
    
    a.record-data {
      color: #0d65fc;
    }
  }
}
</style>
