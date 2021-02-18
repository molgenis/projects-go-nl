<template>
  <li class="pub" :data-uid="pub.uid">
    <p class="pub-data pub-title">{{ pub.title }}</p>
    <p class="pub-data pub-journal">{{ pub.fulljournalname }}</p>
    <p class="pub-data pub-date">{{ pub.sortpubdate }}</p>
    <p class="pub-data pub-authors">{{ pub.authors }}</p>
    <a class="pub-data pub-doi" :href="pub.doi_href">{{ pub.doi_label }}</a>
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
  margin-bottom: 16px;
}

.pub .pub-data {
  color: #3f454b;
  line-height: 1.6;
  margin-bottom: 8px;
  font-weight: 400;
}

.pub .pub-doi {
  color: #017ffd;
}

.pub .pub-title {
  display: block;
  font-size: 14pt;
  color: #000000;
  line-height: 1.4;
}

.pub .pub-journal::after {
  content: ", ";
}

.pub .pub-journal,
.pub .pub-date {
  display: inline;
}

</style>