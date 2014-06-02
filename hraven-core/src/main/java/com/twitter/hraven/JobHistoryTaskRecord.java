package com.twitter.hraven;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

/**
 * @author angad.singh Abstraction of a record to be stored in the
 *         {@link HravenService#JOB_HISTORY_TASK} service.
 */

public class JobHistoryTaskRecord extends HravenRecord<TaskKey, Object> {

  public JobHistoryTaskRecord(RecordCategory dataCategory, TaskKey key, RecordDataKey dataKey,
      Object dataValue) {
    this.setKey(key);
    this.setDataCategory(dataCategory);
    this.setDataKey(dataKey);
    this.setDataValue(dataValue);
  }

  public JobHistoryTaskRecord(RecordCategory dataCategory, TaskKey key, RecordDataKey dataKey,
      Object dataValue, Long submitTime) {
    this(dataCategory, key, dataKey, dataValue);
    setSubmitTime(submitTime);
  }

  public JobHistoryTaskRecord() {

  }

  public JobHistoryTaskRecord(TaskKey jobKey) {
    this.setKey(jobKey);
  }

  public void set(RecordCategory category, RecordDataKey key, String value) {
    this.setDataCategory(category);
    this.setDataKey(key);
    this.setDataValue(value);
  }

  public void write(DataOutput out) throws IOException {
    super.write(out);
  }

  public void readFields(DataInput in) throws IOException {
    super.readFields(in);
  }
}
