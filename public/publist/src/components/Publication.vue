<template>
  <li class="pub" :data-uid="pub.uid">
    <p class="pub-data pub-title"><a :href="pub.doi_url">{{ pub.title }}</a></p>
    <p class="pub-data pub-authors">{{ pub.authors }}</p>
    <p class="pub-data pub-journal">{{ pub.fulljournalname }}</p>
    <p class="pub-data pub-date">{{ pub.sortpubdate }}</p>
    <!-- <a class="pub-data pub-doi" :href="pub.doi_url">{{ pub.doi_url }}</a> -->
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
  line-height: 1.3;
  margin: 0;
  margin-bottom: 6px;
  font-weight: 400;
}

.pub .pub-doi {
  color: #017ffd;
}

.pub .pub-title {
  display: block;
  color: #252525;
  line-height: 1.4;
}

.pub .pub-title a {
    text-decoration: underline;
}

.pub .pub-journal::after {
  content: "\2022";
  margin: 0 6px;
}

.pub .pub-journal,
.pub .pub-date {
  display: inline;
  text-transform: uppercase;
  font-size: 11pt;
  letter-spacing: 1.6px;
  font-weight: 400;
  color: #5D666F;
}

</style>