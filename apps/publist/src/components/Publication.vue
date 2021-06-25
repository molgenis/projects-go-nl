<template>
  <li class="pub" :data-uid="pub.uid">
    <p class="pub-data pub-title">{{ pub.title }}</p>
    <p class="pub-data pub-authors">{{ pub.authors }}</p>
    <div class="pub-meta">
      <p class="pub-data pub-journal">{{ pub.fulljournalname }}</p>
      <p class="pub-data pub-date">{{ pub.sortpubdate.split("-")[0] }}</p>
      <a class="pub-data pub-doi" :href="pub.doi_url">{{ pub.doi_label }}</a>
    </div>
  </li>
</template>

<script setup>
import { defineProps } from "vue";

defineProps({
  pub: Object
});
</script>

<style>
.pub {
  margin-bottom: 1.65em;
}

.pub .pub-data {
  color: #3f454b;
  margin: 0;
  font-weight: 400;
}

.pub .pub-title {
  display: block;
  color: #252525;
  line-height: 1.4;
  margin-bottom: 8px;
  font-size: 16pt;
}

.pub .pub-authors {
  font-size: 14pt;
}

.pub .pub-meta {
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;
  margin-top: 12px;
  font-size: 11pt;
  text-transform: uppercase;
  font-size: 11pt;
  letter-spacing: 1.6px;
  font-weight: 400;
  color: #5D666F;
}


.pub .pub-meta p::after {
  content: "\2022";
  margin: 0 8px;
}

.pub .pub-meta a {
  color: #0d65fc;
}


</style>